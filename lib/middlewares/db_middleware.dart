// ignore_for_file: public_member_api_docs

import 'package:dart_frog/dart_frog.dart';

import 'package:team_ship_dart_frog/server/db_connection.dart';

Middleware get dbMiddleware => (handler) => (context) async {
      final db = await connection.db;

      if (!db.masterConnection.serverCapabilities.supportsOpMsg) {
        return Response(
          statusCode: 500,
          body: 'MongoDB version is too old. Please upgrade to 3.6+',
        );
      } else {
        return await handler(context);
      }
    };
