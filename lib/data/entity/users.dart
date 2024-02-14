class Users {
  String userid;
  String fullname;
  String email;
  String password;
  String birthdate;
  String biography;
  List hobbies;

  Users({
    required this.userid,
    this.fullname = "",
    required this.email,
    required this.password,
    this.birthdate = "",
    this.biography = "",
    required this.hobbies,
  });

  factory Users.fromJson(Map<String, dynamic> json, String key) {
    return Users(
      userid: key,
      fullname: json["fullname"] as String,
      email: json["email"] as String,
      password: json["password"] as String,
      birthdate: json["birthdate"] as String,
      biography: json["biography"] as String,
      hobbies: json["hobbies"] as List,
    );
  }
}
