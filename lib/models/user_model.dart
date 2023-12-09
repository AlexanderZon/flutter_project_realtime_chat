import 'dart:convert';

UserModel usuarioModelFromJson(String str) =>
    UserModel.fromJson(json.decode(str));

String usuarioModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String nombre;
  String email;
  bool online;
  String uid;

  UserModel({
    required this.nombre,
    required this.email,
    required this.online,
    required this.uid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        nombre: json["nombre"],
        email: json["email"],
        online: json["online"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "email": email,
        "online": online,
        "uid": uid,
      };
}
