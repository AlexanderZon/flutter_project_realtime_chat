class UserModel {
  bool online;
  String name;
  String email;
  String uid;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.online,
  });
}
