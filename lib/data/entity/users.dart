class Users {
  String userid;
  String email;
  String password;

  Users({
    required this.userid,
    required this.email,
    required this.password,
  });

  factory Users.fromJson(Map<dynamic, dynamic> json, String key) {
    return Users(
      userid: key,
      email: json["email"] as String,
      password: json["password"] as String,
    );
  }
}
