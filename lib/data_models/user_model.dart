class UserModel {
  String uid;
  String? email;
  String? provider;

  UserModel({
    required this.uid,
    this.email,
    this.provider,
  });
}
