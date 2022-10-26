// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:core';

import 'package:dartz/dartz.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:team_ship_dart_frog/data/models/client_error.dart';

import 'package:team_ship_dart_frog/data/models/user.dart';

class CreateProjectParams {
  final String name;
  final String base64Image;
  final String description;
  final String? githubRepo;
  final String? websiteUrl;
  final String? twitterUrl;
  final String? linkedinUrl;
  final List<Map<String, int>> stackAndCount;
  final String? createdAt;
  final String? updatedAt;
  final String? projectType;
  final bool? shouldCreateRepo;
  final Map<String, dynamic> duration;
  CreateProjectParams({
    required this.name,
    required this.base64Image,
    required this.description,
    this.githubRepo,
    this.websiteUrl,
    this.twitterUrl,
    this.linkedinUrl,
    required this.stackAndCount,
    this.createdAt,
    this.updatedAt,
    this.projectType,
    this.shouldCreateRepo,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'base64Image': base64Image,
      'description': description,
      'githubRepo': githubRepo,
      'websiteUrl': websiteUrl,
      'twitterUrl': twitterUrl,
      'linkedinUrl': linkedinUrl,
      'stackAndCount': stackAndCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'projectType': projectType,
      'shouldCreateRepo': shouldCreateRepo,
      'duration': duration,
    };
  }

  factory CreateProjectParams.fromMap(Map<String, dynamic> map) {
    return CreateProjectParams(
      name: map['name'] as String,
      base64Image: map['base64Image'] as String,
      description: map['description'] as String,
      githubRepo:
          map['githubRepo'] != null ? map['githubRepo'] as String : null,
      websiteUrl:
          map['websiteUrl'] != null ? map['websiteUrl'] as String : null,
      twitterUrl:
          map['twitterUrl'] != null ? map['twitterUrl'] as String : null,
      linkedinUrl:
          map['linkedinUrl'] != null ? map['linkedinUrl'] as String : null,
      stackAndCount: List<Map<String, int>>.from(
        (map['stackAndCount'] as List).map(
          (x) => x,
        ),
      ),
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      projectType:
          map['projectType'] != null ? map['projectType'] as String : null,
      shouldCreateRepo: map['shouldCreateRepo'] != null
          ? map['shouldCreateRepo'] as bool
          : null,
      duration: Map<String, dynamic>.from(
        map['duration'] as Map<String, dynamic>,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  ///
  Future<Either<ClientError, Map<String, dynamic>>> createProject(
    DbCollection collection,
    User user,
  ) async {
    final data = {
      ...toMap(),
      'creator': user.toMap(),
    };
    final result = await collection.insertOne(data);
    if (result.hasWriteErrors) {
      return left(
        ClientError(
          message: 'an error occured trying to create project',
        ),
      );
    }
    return right(data);
  }

  factory CreateProjectParams.fromJson(String source) =>
      CreateProjectParams.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
