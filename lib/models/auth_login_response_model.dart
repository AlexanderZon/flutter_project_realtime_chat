// To parse this JSON data, do
//
//     final authLoginResponseModel = authLoginResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:realtime_chat_project/models/user_model.dart';

AuthLoginResponseModel authLoginResponseModelFromJson(String str) =>
    AuthLoginResponseModel.fromJson(json.decode(str));

String authLoginResponseModelToJson(AuthLoginResponseModel data) =>
    json.encode(data.toJson());

class AuthLoginResponseModel {
  bool ok;
  UserModel usuario;
  String token;

  AuthLoginResponseModel({
    required this.ok,
    required this.usuario,
    required this.token,
  });

  factory AuthLoginResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthLoginResponseModel(
        ok: json["ok"],
        usuario: UserModel.fromJson(json["usuario"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuario": usuario.toJson(),
        "token": token,
      };
}
