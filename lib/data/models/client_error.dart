// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ClientError {
  ClientError({
    required this.message,
  });
  final String message;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
    };
  }

  factory ClientError.fromMap(Map<String, dynamic> map) {
    return ClientError(
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientError.fromJson(String source) =>
      ClientError.fromMap(json.decode(source) as Map<String, dynamic>);
}
