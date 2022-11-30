import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  late String _name;
  late String _email;
  late String _id;
  late String _role;
  static late String accessToken;
  List<String> originalID = [];

  String get name => _name;
  String get email => _email;
  String get id => _id;
  String get role => _role;

  set changeName(String name) => _name = name;
  set changeEmail(String email) => _email = email;

  initUser(name,email,id,role,accessToken1){
    print("initUser");
    _name = name;
    _email = email;
    _id = id;
    _role = role;
    accessToken = accessToken1;
    print(accessToken);
  }
}