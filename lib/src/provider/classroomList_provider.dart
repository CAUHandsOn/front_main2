import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/classEntity.dart';
import '../ui/home.dart';

class ClassroomListProvider extends ChangeNotifier {
  List<ClassEntity> _classroomList = [];
  final List<String> _classroomListString = [];
  List<ClassEntity> get classroomList => _classroomList;
  List<String> get classroomListString => _classroomListString;

  getClassroomList() async {
    String url = 'https://bho.ottitor.shop/room';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyMDE4NjI3NCIsIm5hbWUiOiLquYDrqoXsirkiLCJlbWFpbCI6Im1za0BjYXUuYWMua3IiLCJpZCI6IjIwMTg2Mjc0Iiwicm9sZSI6InN0dWRlbnQiLCJhdXRoIjoic3R1ZGVudCIsImV4cCI6MTY3NzY3MzQwNH0.XH4WDfYDU15yqxOenoxd8Gy_8W71D9k9YIrktFN8Iidq6AKFU0oNJv_JVIY1Jifjt3Uaj6k5BBNOwq8LhBiiEA'
        // 'Authorization': 'Bearer $accessToken'
      },
    );
    log(jsonDecode(response.body).toString());
    if (response.statusCode == 200) {
      _classroomList =
          await jsonDecode(response.body)['data'].map<ClassEntity>((data) {
        if (_classroomList.isEmpty) {
          _classroomListString.add((ClassEntity.fromMap(data).name));
        }
        return ClassEntity.fromMap(data);
      }).toList();
    }
    notifyListeners();
  }
  //  j3m2rfrokwegwe
  // sajf34k2rl2332rwf213

  // getStudentClassroomInfo(String id) async {
  //   String url = 'https://bho.ottitor.shop/room/$id';
  //   http.Response response = await http.get(
  //     Uri.parse(url),
  //     headers: <String,String>{
  //       'Content-Type' : 'application/json;charset=UTF-8'
  //     },
  //   );
  //   if (response.statusCode == 200){
  //     print(response.body);
  //   }
  //   else{
  //     print("오류 발생");
  //   }
  //   notifyListeners();
  // }
  //
  // postEntrance(String id) async {
  //   String url = 'https://bho.ottitor.shop/room/$id/me';
  //   http.Response response = await http.post(
  //     Uri.parse(url),
  //     headers: <String,String>{
  //       'Content-Type' : 'application/json;charset=UTF-8',
  //       'Authorization' : '2018',
  //     },
  //   );
  //   if (response.statusCode == 200){
  //     print(response.body);
  //     print("출입");
  //   }
  //   else{
  //     print("오류 발생");
  //   }
  //   notifyListeners();
  // }

  // Future<String> loadJsonFile(context) {
  //   print("loading the classroomList file . . . ");
  //   return Future.value(DefaultAssetBundle.of(context)
  //       .loadString("assets/json/classroomList_response.json"));
  // }
  //
  // loadClassroomList(context) async {
  //   print("loadClassroomList called");
  //   String data = await loadJsonFile(context);
  //   print("data = $data");
  //   _classroomList = jsonDecode(data)['data'].map<Classroom>((data) {
  //     return Classroom.fromJson(data);
  //   }).toList();
  //   print(_classroomList);
  //   notifyListeners();
  // }

// postClassroom(Map<String,dynamic> data) async{
//   String url = 'https://bho.ottitor.shop/room';
//
//   http.Response response = await http.post(
//       Uri.parse(url),
//       headers: <String,String>{
//         'Content-Type' : 'application/json;charset=UTF-8'
//       },
//       body: jsonEncode(data)
//   );
//   if (response.statusCode == 200){
//     print("postClassroom success!");
//     return;
//   } else{
//     throw Exception('Failed to postClassroom');
//   }
// }

}
