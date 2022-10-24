// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:team_ship_dart_frog/data/models/client_error.dart';
import 'package:team_ship_dart_frog/data/models/location.dart';
import 'package:team_ship_dart_frog/data/models/user.dart';

class SignupParams {
  final String? fullName;
  final String? nickName;
  final String? email;
  final String? password;
  final String? avatarUrl;
  final String? bio;
  final Location? location;
  final String? phoneNumber;
  final String? githubUsername;
  final String? twitterUsername;
  final String? createdAt;
  final String? updatedAt;
  SignupParams({
    required this.fullName,
    required this.nickName,
    required this.email,
    required this.password,
    this.avatarUrl,
    this.bio,
    this.location,
    this.phoneNumber,
    required this.githubUsername,
    this.twitterUsername,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'nickName': nickName,
      'email': email,
      'password': base64Encode(password!.codeUnits),
      'avatarUrl': avatarUrl,
      'bio': bio,
      'location': location?.toMap(),
      'phoneNumber': phoneNumber,
      'githubUsername': githubUsername,
      'twitterUsername': twitterUsername,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory SignupParams.fromMap(Map<String, dynamic> map) {
    return SignupParams(
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
      nickName: map['nickName'] != null ? map['nickName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      avatarUrl: map['avatarUrl'] != null ? map['avatarUrl'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      location: map['location'] != null
          ? Location.fromMap(map['location'] as Map<String, dynamic>)
          : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      githubUsername: map['githubUsername'] != null
          ? map['githubUsername'] as String
          : null,
      twitterUsername: map['twitterUsername'] != null
          ? map['twitterUsername'] as String
          : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SignupParams.fromJson(String source) =>
      SignupParams.fromMap(json.decode(source) as Map<String, dynamic>);

  Future<bool> _userExists(DbCollection collection) async {
    return await collection.findOne(where.eq('email', email)) != null;
  }

  Future<Either<ClientError, User>> createUser(
    DbCollection collection,
  ) async {
    final usrExists = await _userExists(collection);
    if (usrExists) {
      return left(
        ClientError(
          message: 'User already exists',
        ),
      );
    }
    final result = await collection.insertOne(toMap());
    if (result.hasWriteErrors) {
      return left(
        ClientError(
          message: 'Error creating user',
        ),
      );
    } else {
      return right(
        User.fromMap(result.document ?? {}).copyWith(
          id: result.id.toString(),
        ),
      );
    }
  }

  ///
  Either<ClientError, bool> validateForm() {
    if (fullName == null || fullName!.isEmpty) {
      return left(
        ClientError(
          message: 'Full name is required',
        ),
      );
    } else if (nickName == null || nickName!.isEmpty) {
      return left(
        ClientError(
          message: 'Nick name is required',
        ),
      );
    } else if (email == null || email!.isEmpty) {
      return left(
        ClientError(
          message: 'Email is required',
        ),
      );
    } else if (password == null || password!.isEmpty) {
      return left(
        ClientError(
          message: 'Password is required',
        ),
      );
    } else if (password!.length < 6) {
      return left(
        ClientError(
          message: 'Password must be at least 6 characters',
        ),
      );
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$')
            .hasMatch(password!) ==
        false) {
      return left(
        ClientError(
          message: 'Password must contain at least one uppercase letter, one '
              'lowercase letter and one number',
        ),
      );
    } else if (githubUsername == null || githubUsername!.isEmpty) {
      return left(
        ClientError(
          message: 'Github username is required',
        ),
      );
    }
    return right(true);
  }
}
