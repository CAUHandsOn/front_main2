import 'package:handson/src/model/userEntity.dart';

class RoomMembers{
  UserEntity _user;
  String _getIn;

  UserEntity get user => _user;
  String get getIn => _getIn;

  RoomMembers(
      this._user,
      this._getIn,
      );

  RoomMembers.fromJson(Map<String,dynamic> json):
    _user = UserEntity.fromJson(json['user']),
    _getIn = json['getIn'] as String;
}