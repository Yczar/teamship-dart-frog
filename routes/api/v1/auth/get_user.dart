import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:team_ship_dart_frog/data/models/client_data.dart';
import 'package:team_ship_dart_frog/server/db_connection.dart';
import 'package:team_ship_dart_frog/utils/constants/db_constants.dart';
import 'package:team_ship_dart_frog/utils/helpers/app_helper.dart';
import 'package:team_ship_dart_frog/utils/helpers/user_helper.dart';

Future<Response> onRequest(RequestContext context) async {
  final query = context.request.url.queryParameters;
  final token = context.request.headers['Authorization']?.split(' ').last;
  final userId = query['userId'];
  final db = await connection.db;
  final collection = db.collection(userCollection);

  final method = context.request.method;
  if (method != HttpMethod.get) {
    return Response(
      statusCode: HttpStatus.methodNotAllowed,
      body: 'Method not allowed',
    );
  }
  if (token == null) {
    return Response(
      statusCode: HttpStatus.unauthorized,
      body: 'Unauthorized',
    );
  } else {
    if (userId == null) {
      final user = await UserHelper.getUserFromToken(
        token,
        collection,
      );
      final userToken = await AppHelper.signData(
        user,
        collection,
      );
      return Response(
        body: ClientData(
          data: user.toMap(),
          message: 'User found',
          token: userToken,
        ).toJson(),
      );
    } else {
      final user = await UserHelper.getUserFromId(
        userId,
        collection,
      );

      if (user == null) {
        return Response(
          statusCode: HttpStatus.notFound,
          body: 'User not found',
        );
      } else {
        final userToken = await AppHelper.signData(
          user,
          collection,
        );
        return Response(
          body: ClientData(
            data: user.toMap(),
            message: 'User found',
            token: userToken,
          ).toJson(),
        );
      }
    }
  }
}
