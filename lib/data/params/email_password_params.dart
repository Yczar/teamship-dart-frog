// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:team_ship_dart_frog/data/models/client_error.dart';
import 'package:team_ship_dart_frog/data/models/user.dart';

class EmailPasswordParams {
  EmailPasswordParams({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': base64Encode(password.codeUnits),
    };
  }

  factory EmailPasswordParams.fromMap(Map<String, dynamic> map) {
    return EmailPasswordParams(
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EmailPasswordParams.fromJson(String source) =>
      EmailPasswordParams.fromMap(json.decode(source) as Map<String, dynamic>);

  Future<Either<ClientError, User>> _userExists(DbCollection collection) async {
    final user = await collection.findOne(where.eq('email', email));
    if (user == null) {
      return left(
        ClientError(
          message: 'User does not exist',
        ),
      );
    }
    return right(
      User.fromMap(user),
    );
  }

  Future<Either<ClientError, User>> validate(DbCollection collection) async {
    final userExists = await _userExists(collection);
    if (email.isEmpty) {
      return left(
        ClientError(
          message: 'Email cannot be empty',
        ),
      );
    } else if (password.isEmpty) {
      return left(
        ClientError(
          message: 'Password cannot be empty',
        ),
      );
    } else {
      return userExists.fold(
        left,
        (data) {
          if (data.password == base64Encode(password.codeUnits)) {
            return right(data);
          } else {
            return left(
              ClientError(
                message:
                    'Incorrect password ${data.password} ${base64Encode(password.codeUnits)}',
              ),
            );
          }
        },
      );
    }
  }
}
