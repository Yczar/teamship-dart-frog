// ignore_for_file: public_member_api_docs

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:team_ship_dart_frog/data/models/user.dart';

import '../constants/api_constants.dart';

class AppHelper {
  static Future<String> signData(
    User data,
    DbCollection collection,
  ) async {
    final jwt = JWT(
      data.toJson(),
      jwtId: data.email,
      issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
      subject: data.email,
    );
    final signedToken = jwt.sign(
      SecretKey(jwtSecret),
    );
    await collection.update(
      where.eq('email', data.email),
      modify.set('token', signedToken),
    );
    return signedToken;
  }

  static Future<bool> verifyToken(
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
      return false;
    }
    return true;
  }
}
