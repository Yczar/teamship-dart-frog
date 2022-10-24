// ignore_for_file: public_member_api_docs

import 'package:dart_frog/dart_frog.dart';
import 'package:team_ship_dart_frog/data/models/client_error.dart';
import 'package:team_ship_dart_frog/server/db_connection.dart';
import 'package:team_ship_dart_frog/utils/constants/api_constants.dart';
import 'package:team_ship_dart_frog/utils/constants/db_constants.dart';

import 'package:team_ship_dart_frog/utils/helpers/app_helper.dart';

Middleware get bearerAuthMiddleware => (handler) {
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
          final verifyToken = await AppHelper.verifyToken(token, collection);
          if (verifyToken) {
            return await handler(context);
          } else {
            return Response(
              statusCode: 401,
              body: ClientError(
                message: 'Unauthorized',
              ).toJson(),
            );
          }
        }
      };
    };
