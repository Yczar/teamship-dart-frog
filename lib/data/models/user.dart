// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:team_ship_dart_frog/data/models/location.dart';

class User extends Equatable {
  const User({
    this.id,
    this.fullName,
    this.nickName,
    this.email,
    this.password,
    this.avatarUrl,
    this.bio,
    this.location,
    this.phoneNumber,
    this.githubUsername,
    this.twitterUsername,
    this.createdAt,
    this.updatedAt,
  });
  final String? id;
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

  User copyWith({
    String? id,
    String? fullName,
    String? nickName,
    String? email,
    String? password,
    String? avatarUrl,
    String? bio,
    Location? location,
    String? phoneNumber,
    String? githubUsername,
    String? twitterUsername,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      nickName: nickName ?? this.nickName,
      email: email ?? this.email,
      password: password ?? this.password,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      githubUsername: githubUsername ?? this.githubUsername,
      twitterUsername: twitterUsername ?? this.twitterUsername,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'nickName': nickName,
      'email': email,
      'password': password == null ? '' : base64Encode(password!.codeUnits),
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

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] != null ? (map['_id'] as ObjectId).$oid : null,
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

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, fullName: $fullName, nickName: $nickName, email: $email, password: $password, avatarUrl: $avatarUrl, bio: $bio, location: $location, phoneNumber: $phoneNumber, githubUsername: $githubUsername, twitterUsername: $twitterUsername, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        nickName,
        email,
        password,
        avatarUrl,
        bio,
        location,
        phoneNumber,
        githubUsername,
        twitterUsername,
        createdAt,
        updatedAt,
      ];
}
