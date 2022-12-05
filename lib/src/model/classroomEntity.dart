import 'package:handson/src/model/roomMembers.dart';

class ClassroomEntity{
  List<RoomMembers> _roomMembers = [];

  List<RoomMembers> get roomMembers => _roomMembers;


  ClassroomEntity(
      this._roomMembers
      );

  ClassroomEntity.fromJson(Map<String,dynamic> json):
        _roomMembers = (json['roomMembers'] as List<dynamic>).map((item) => RoomMembers.fromJson(item)).toList();

}