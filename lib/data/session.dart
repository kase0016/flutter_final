import 'dart:ffi';
import 'package:flutter/material.dart';

class SessionResponse {
  final String message;
  final String sessionId;
  final String code;

  SessionResponse({
    required this.message,
    required this.sessionId,
    required this.code,
  });

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return SessionResponse(
      message: json['message'],
      sessionId: json['session_id'],
      code: json['code'].toString(), // Ensure 'code' is always a String
    );
  }
}
