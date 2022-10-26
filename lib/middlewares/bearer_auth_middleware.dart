// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:team_ship_dart_frog/data/models/client_error.dart';
import 'package:team_ship_dart_frog/data/models/user.dart';
import 'package:team_ship_dart_frog/server/db_connection.dart';
import 'package:team_ship_dart_frog/services/github_service.dart';
import 'package:team_ship_dart_frog/utils/constants/api_constants.dart';
import 'package:team_ship_dart_frog/utils/constants/db_constants.dart';

import 'package:team_ship_dart_frog/utils/helpers/app_helper.dart';

Middleware get bearerAuthMiddleware => (Handler handler) {
      return (context) async {
        final api = context.request.uri.pathSegments.last;
        if (ignoreAuthorization.contains(api)) {
          return await handler(context);
        }
        final token = context.request.headers['Authorization']?.split(' ').last;
        final db = await connection.db;
        final collection = db.collection(userCollection);
        if (token == null) {
          return Response(
            statusCode: 401,
            body: ClientError(
              message: 'Unauthorized',
            ).toJson(),
          );
        }
        final userMap = await collection.findOne({
          'token': token,
        });
        if (userMap == null) {
          return Response(
            statusCode: 401,
            body: ClientError(
              message: 'Unauthorized',
            ).toJson(),
          );
        } else {
          final user = User.fromMap(userMap);
          final verifyToken = await AppHelper.verifyToken(token, collection);
          final verifyGithub =
              await GithubService.instance.verifyGithubUsername(
            user.githubUsername ?? '',
            // 'Yczar',
          );
          if (!verifyGithub) {
            return Response(
              statusCode: HttpStatus.unauthorized,
              body: ClientError(
                message:
                    'There seems to be a problem with your github account. '
                    'Please update your github username in your profile.',
              ).toJson(),
            );
          }
          if (verifyToken) {
            return await handler
                .use(provider<Token>((context) => token))
                .use(
                  provider<User>(
                    (context) => user,
                  ),
                )
                .call(context);
          } else {
            return Response(
              statusCode: HttpStatus.unauthorized,
              body: ClientError(
                message: 'Unauthorized',
              ).toJson(),
            );
          }
        }
      };
    };

typedef Token = String;
