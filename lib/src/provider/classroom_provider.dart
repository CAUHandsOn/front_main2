import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:handson/src/model/classroom.dart';
import 'package:handson/src/provider/entrance_provider.dart';
import 'package:handson/src/provider/user_provider.dart';
import 'package:http/http.dart' as http;

import '../model/roomMembers.dart';
import '../model/userEntity.dart';

class ClassroomProvider extends ChangeNotifier {
  late Classroom _classroomInfo;
  bool _isLoaded = false;
  Classroom get classroomInfo => _classroomInfo;
  bool get isLoaded => _isLoaded;

  late Classroom _StudentClassroomInfo;
  bool is_loaded = false;
  List<UserEntity> _userList = [];
  String _buildingName = '';

  Classroom get StudentClassroomInfo => _StudentClassroomInfo;
  List<UserEntity> get userList => _userList;
  String get buildingName => _buildingName;


  callRoomInfoAPI() async {
    String url = 'https://bho.ottitor.shop/room/${EntranceProvider.deviceId}';

    http.Response response =
        await http.get(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
      'Authorization': 'Bearer ${UserProvider.accessToken}'
    });
    if (response.statusCode == 200) {
      print("callRoomInfoAPI success!");
      Map<String, dynamic> json = jsonDecode(response.body);
      _classroomInfo = Classroom.fromJson(json['data']);
      _isLoaded = true;
      print("callRoomInfoAPI Notify");
      notifyListeners();
    } else {
      print(response.body);
      throw Exception('Failed to Exit');
    }
    return 'finish';
  }


  postEntrance(String roomId) async {
    String url = 'https://bho.ottitor.shop/room/$roomId/me';
    http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer ${UserProvider.accessToken}'
        // 'Authorization': 'Bearer $accessToken'
      },
    );
    if (response.statusCode == 200) {
      print("출입 성공 ${response.body}");
    } else {
      print("출입 오류 발생");
    }
    notifyListeners();
  }

  getStudentClassroomInfo(String id) async {
    String url = 'https://bho.ottitor.shop/room/$id';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer ${UserProvider.accessToken}'
      },
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body)['data']);
      _userList = await jsonDecode(response.body)['data']['roomMembers']
          .where((data) => RoomMembers.fromJson(data).user.role == 'student')
          .map<UserEntity>((data) => RoomMembers.fromJson(data).user)
          .toList();
    } else {
      print("오류 발생");
    }
    notifyListeners();
  }


}
