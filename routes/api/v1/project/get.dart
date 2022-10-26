import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:team_ship_dart_frog/data/models/client_data.dart';
import 'package:team_ship_dart_frog/data/models/client_error.dart';
import 'package:team_ship_dart_frog/data/models/user.dart';
import 'package:team_ship_dart_frog/middlewares/bearer_auth_middleware.dart';
import 'package:team_ship_dart_frog/server/db_connection.dart';

Future<Response> onRequest(RequestContext context) async {
  final method = context.request.method;
  final query = context.request.url.queryParameters;
  final id = query['id'];
  final user = context.read<User>();
  final token = context.read<Token>();
  final db = await connection.db;
  final collection = db.collection('projects');
  if (method != HttpMethod.get) {
    return Response(
      statusCode: HttpStatus.methodNotAllowed,
      body: 'Method not allowed',
    );
  }
  if (id != null) {
    final project = await collection.findOne(
      where.id(
        ObjectId.fromHexString(id),
      ),
    );
    if (project == null) {
      return Response(
        statusCode: HttpStatus.notFound,
        body: ClientError(
          message: 'Project not found',
        ).toJson(),
      );
    }
    return Response(
      body: ClientData(
        message: 'Project found',
        data: project,
        token: token,
      ).toJson(),
    );
  }

  final projects = await collection
      .find(
        where.eq('creator', user.toMap()),
      )
      .toList();
  return Response(
    body: ClientData(
      message: 'Projects found',
      data: {
        'projects': projects,
        'count': projects.length,
      },
      token: token,
    ).toJson(),
  );
}
