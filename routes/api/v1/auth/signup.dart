import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:team_ship_dart_frog/data/models/client_data.dart';
import 'package:team_ship_dart_frog/data/models/client_error.dart';
import 'package:team_ship_dart_frog/data/params/signup_params.dart';
import 'package:team_ship_dart_frog/server/db_connection.dart';
import 'package:team_ship_dart_frog/services/github_service.dart';
import 'package:team_ship_dart_frog/utils/constants/db_constants.dart';

Future<Response> onRequest(RequestContext context) async {
  final body = await context.request.body();
  final method = context.request.method;
  final params = SignupParams.fromJson(body);
  final db = await connection.db;
  final collection = db.collection(userCollection);
  final validateUser = params.validateForm();
  final verifyGithub = await GithubService.instance.verifyGithubUsername(
    params.githubUsername ?? '',
  );
  if (method != HttpMethod.post) {
    return Response(
      statusCode: HttpStatus.methodNotAllowed,
      body: ClientError(
        message: 'Method not allowed',
      ).toJson(),
    );
  }

  if (!verifyGithub) {
    return Response(
      statusCode: HttpStatus.unauthorized,
      body: ClientError(
        message: 'There seems to be a problem with your github account. '
            'Please update your github username in your profile.',
      ).toJson(),
    );
  }
  return validateUser.fold(
    (err) => Response(
      statusCode: HttpStatus.badRequest,
      body: err.toJson(),
    ),
    (data) async {
      final user = await params.createUser(collection);
      return user.fold(
        (err) => Response(
          statusCode: HttpStatus.badRequest,
          body: err.toJson(),
        ),
        (data) {
          return Response(
            body: ClientData(
              message: 'User created',
              data: data.toMap(),
            ).toJson(),
          );
        },
      );
    },
  );
}
