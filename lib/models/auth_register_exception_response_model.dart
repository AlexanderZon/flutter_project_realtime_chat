// To parse this JSON data, do
//
//     final authRegisterExceptionResponseModel = authRegisterExceptionResponseModelFromJson(jsonString);

import 'dart:convert';

AuthRegisterExceptionResponseModel authRegisterExceptionResponseModelFromJson(
        String str) =>
    AuthRegisterExceptionResponseModel.fromJson(json.decode(str));

String authRegisterExceptionResponseModelToJson(
        AuthRegisterExceptionResponseModel data) =>
    json.encode(data.toJson());

class AuthRegisterExceptionResponseModel {
  bool ok;
  String? msg;
  Errors? errors;

  AuthRegisterExceptionResponseModel({
    required this.ok,
    this.msg,
    this.errors,
  });

  factory AuthRegisterExceptionResponseModel.fromJson(
          Map<String, dynamic> json) =>
      AuthRegisterExceptionResponseModel(
        ok: json["ok"],
        msg: json["msg"],
        errors: json["errors"] == null ? null : Errors.fromJson(json["errors"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "errors": errors?.toJson(),
      };
}

class Errors {
  Error? password;
  Error? nombre;
  Error? email;

  Errors({
    this.password,
    this.nombre,
    this.email,
  });

  String getErrorsMessage() {
    String message = '';
    if (password != null) {
      message = '${message}${password!.msg}. \n';
    }
    if (email != null) {
      message = '${message}${email!.msg}. \n';
    }
    if (nombre != null) {
      message = '${message}${nombre!.msg}. \n';
    }
    return message;
  }

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
        password:
            json["password"] == null ? null : Error.fromJson(json["password"]),
        nombre: json["nombre"] == null ? null : Error.fromJson(json["nombre"]),
        email: json["email"] == null ? null : Error.fromJson(json["email"]),
      );

  Map<String, dynamic> toJson() => {
        "password": password?.toJson(),
        "nombre": nombre?.toJson(),
        "email": email?.toJson(),
      };
}

class Error {
  String type;
  String value;
  String msg;
  String path;
  String location;

  Error({
    required this.type,
    required this.value,
    required this.msg,
    required this.path,
    required this.location,
  });

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        type: json["type"],
        value: json["value"],
        msg: json["msg"],
        path: json["path"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "value": value,
        "msg": msg,
        "path": path,
        "location": location,
      };
}
