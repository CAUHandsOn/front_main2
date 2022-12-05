class UserEntity{
  String _id;
  String _name;
  String _email;
  String _role;

  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get role => _role;

  UserEntity(
      this._id,
      this._name,
      this._email,
      this._role
      );

  UserEntity.fromJson(Map<String,dynamic> json):
    _id = json['id'] as String,
    _name = json['name'] as String,
    _email = json['email'] as String,
    _role = json['role'] as String;
}