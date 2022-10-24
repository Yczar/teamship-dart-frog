// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ClientData {
  final String message;
  final Map<String, dynamic> data;
  final String? token;
  ClientData({
    this.token,
    required this.message,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'data': data,
      'token': token,
    };
  }

  factory ClientData.fromMap(Map<String, dynamic> map) {
    return ClientData(
      message: map['message'] as String,
      data: Map<String, dynamic>.from(
        map['data'] as Map<String, dynamic>,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientData.fromJson(String source) =>
      ClientData.fromMap(json.decode(source) as Map<String, dynamic>);
}
