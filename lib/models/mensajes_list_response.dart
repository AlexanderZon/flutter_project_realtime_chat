// To parse this JSON data, do
//
//     final mensajesListResponse = mensajesListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:realtime_chat_project/models/mensaje_model.dart';

MensajesListResponse mensajesListResponseFromJson(String str) =>
    MensajesListResponse.fromJson(json.decode(str));

String mensajesListResponseToJson(MensajesListResponse data) =>
    json.encode(data.toJson());

class MensajesListResponse {
  bool ok;
  List<Mensaje> mensajes;

  MensajesListResponse({
    required this.ok,
    required this.mensajes,
  });

  factory MensajesListResponse.fromJson(Map<String, dynamic> json) =>
      MensajesListResponse(
        ok: json["ok"],
        mensajes: List<Mensaje>.from(
            json["mensajes"].map((x) => Mensaje.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "mensajes": List<dynamic>.from(mensajes.map((x) => x.toJson())),
      };
}
