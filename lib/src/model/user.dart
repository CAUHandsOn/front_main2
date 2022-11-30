class User {
  String id;
  String name;
  String email;
  String password;
  String role; // student or prof
  String accessToken;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.role,
      required this.accessToken
      });


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['role'] = role;
    return data;
  }
}
