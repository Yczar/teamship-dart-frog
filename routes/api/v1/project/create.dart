import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:team_ship_dart_frog/data/models/client_data.dart';
import 'package:team_ship_dart_frog/data/models/client_error.dart';
import 'package:team_ship_dart_frog/data/models/user.dart';
import 'package:team_ship_dart_frog/data/params/create_project_params.dart';
import 'package:team_ship_dart_frog/server/db_connection.dart';

Future<Response> onRequest(RequestContext context) async {
  final user = context.read<User>();
  final body = await context.request.body();
  final method = context.request.method;
  final params = CreateProjectParams.fromJson(body);
  final db = await connection.db;
  final collection = db.collection('projects');
  if (method != HttpMethod.post) {
    return Response(
      statusCode: HttpStatus.methodNotAllowed,
      body: ClientError(
        message: 'Method not allowed',
      ).toJson(),
    );
  }

  final createProject = await params.createProject(
    collection,
    user,
  );

  return createProject.fold(
    (err) => Response(
      statusCode: HttpStatus.badRequest,
      body: err.toJson(),
    ),
    (data) {
      return Response(
        body: ClientData(
          message: 'Project created',
          data: data,
        ).toJson(),
      );
    },
  );
}
