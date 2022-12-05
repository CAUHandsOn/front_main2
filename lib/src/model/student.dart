class Student {
  String _name;
  String _id;
  String _email;
  String _role;

  String get name => _name;
  String get id => _id;
  String get email => _email;
  String get role => _role;

  Student(
    this._name,
    this._id,
      this._email,
      this._role,
  );

  Student.fromJson(Map<String, dynamic> json)
      : _name = json['name'] as String,
        _id = json['id'] as String,
        _email = json['email'] as String,
        _role = json['role'] as String;

}
