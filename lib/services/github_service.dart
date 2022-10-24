// ignore_for_file: public_member_api_docs

import 'package:github/github.dart';

class GithubService {
  factory GithubService() => _instance;
  GithubService._();
  static final GithubService _instance = GithubService._();

  final GitHub github = GitHub(
    auth: Authentication.withToken(''),
  );

  Future<bool> verifyGithubUsername(String userName) async {
    try {
      final isUser = await github.users.isUser(userName);
      return isUser;
    } on Exception {
      return false;
    }
  }
}
