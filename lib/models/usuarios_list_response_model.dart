// To parse this JSON data, do
//
//     final usuariosListResponse = usuariosListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:realtime_chat_project/models/user_model.dart';

UsuariosListResponse usuariosListResponseFromJson(String str) =>
    UsuariosListResponse.fromJson(json.decode(str));

String usuariosListResponseToJson(UsuariosListResponse data) =>
    json.encode(data.toJson());

class UsuariosListResponse {
  bool ok;
  List<UserModel> usuarios;

  UsuariosListResponse({
    required this.ok,
    required this.usuarios,
  });

  factory UsuariosListResponse.fromJson(Map<String, dynamic> json) =>
      UsuariosListResponse(
        ok: json["ok"],
        usuarios: List<UserModel>.from(
            json["usuarios"].map((x) => UserModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
      };
}
