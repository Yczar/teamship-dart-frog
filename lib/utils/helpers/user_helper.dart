// ignore_for_file: public_member_api_docs

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:team_ship_dart_frog/data/models/user.dart';

import 'package:team_ship_dart_frog/utils/constants/api_constants.dart';

class UserHelper {
  static Future<User> getUserFromToken(
    String token,
    DbCollection collection,
  ) async {
    final jwt = JWT.verify(
      token,
      SecretKey(jwtSecret),
    );
    final user = await collection.findOne(
      where.eq(
        'email',
        User.fromMap(jwt.payload as Map<String, dynamic>).email,
      ),
    );
    if (user == null) {
      return const User();
    }
    return User.fromMap(user);
  }

  static Future<User?> getUserFromEmail(
    String email,
    DbCollection collection,
  ) async {
    final user = await collection.findOne(
      where.eq(
        'email',
        email,
      ),
    );
    if (user == null) {
      return null;
    }
    return User.fromMap(user);
  }

  static Future<User?> getUserFromId(
    String id,
    DbCollection collection,
  ) async {
    final user = await collection.findOne(
      where.eq(
        '_id',
        ObjectId.fromHexString(id),
      ),
    );
    if (user == null) {
      return null;
    }
    return User.fromMap(user);
  }
}
