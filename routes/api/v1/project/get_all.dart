import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:team_ship_dart_frog/data/models/client_data.dart';
import 'package:team_ship_dart_frog/data/models/user.dart';
import 'package:team_ship_dart_frog/middlewares/bearer_auth_middleware.dart';
import 'package:team_ship_dart_frog/server/db_connection.dart';

Future<Response> onRequest(RequestContext context) async {
  final method = context.request.method;
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
  final projects = await collection
      .find(
          // where.eq('creator', user.toMap()),
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
