// To parse this JSON data, do
//
//     final authRegisterSuccessResponse = authRegisterSuccessResponseFromJson(jsonString);

import 'dart:convert';

import 'package:realtime_chat_project/models/user_model.dart';

AuthRegisterSuccessResponseModel authRegisterSuccessResponseModelFromJson(
        String str) =>
    AuthRegisterSuccessResponseModel.fromJson(json.decode(str));

String authRegisterSuccessResponseModelToJson(
        AuthRegisterSuccessResponseModel data) =>
    json.encode(data.toJson());

class AuthRegisterSuccessResponseModel {
  bool ok;
  UserModel usuario;
  String token;

  AuthRegisterSuccessResponseModel({
    required this.ok,
    required this.usuario,
    required this.token,
  });

  factory AuthRegisterSuccessResponseModel.fromJson(
          Map<String, dynamic> json) =>
      AuthRegisterSuccessResponseModel(
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
