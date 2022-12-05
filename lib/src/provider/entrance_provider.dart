import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:handson/src/provider/sharedPreference_provider.dart';
import 'package:handson/src/provider/user_provider.dart';
import 'package:http/http.dart' as http;

class EntranceProvider extends ChangeNotifier {
  int idleTime = 0;
  bool isConnected = false;
  bool isInited = false;
  static late String deviceId = '34:14:B5:41:A2:7E';

  // 맨처음 singnal을 받으면 userProvider에서 정보를 받아서 서버로 전송
  _callEnterAPI(SPFProvider pvdSPF) async {
    isConnected = true;
    String url = 'https://bho.ottitor.shop/room/$deviceId/me';

    http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization' : 'Bearer ${UserProvider.accessToken}'
        });

    if (response.statusCode == 200) {
      print("callEnterAPI success!");
      print('CallEnterAPI Notify');

      if (pvdSPF != null){ //학생이면 출입 로그 추가
        var classroomName = jsonDecode(response.body)['data']['room']['name'];
        var getInTime = jsonDecode(response.body)['data']['getIn'];

        if (!pvdSPF.decodedMap.containsKey(classroomName)){
          pvdSPF.decodedMap[classroomName] = [];
        }
        pvdSPF.decodedMap[classroomName]!.add(getInTime);
        pvdSPF.saveData('example', pvdSPF.decodedMap);
      }

      notifyListeners();
      return;
    } else {
      print(response.body);
      throw Exception('Failed to Enter');
    }
  }

  // idletime이 60초 이상 지속되면 서버로 정보 전송
  void _callExitAPI() async{
    isConnected = false;
    String url = 'https://bho.ottitor.shop/room/$deviceId/me';

    http.Response response = await http.delete(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          'Authorization' : 'Bearer ${UserProvider.accessToken}'
        });
    if (response.statusCode == 200) {
      print("callExitAPI success!");
      return;
    } else {
      print(response.body);
      throw Exception('Failed to Exit');
    }
  }

  // 맨 처음 프로그램 시작시 이 함수를 통해서 타이머를 실행시킨다.
  // 백엔드에서 매 초마다 idleTime수행
  void initTimer() {
    if (isInited) {
      return;
    }
    isInited = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      idleTime++;
      print(idleTime);
      if (idleTime >= 20 && isConnected == true) {
        isConnected = false;
        _callExitAPI();
        print('initTimer Notify');
        notifyListeners();
      }
    });
  }

  // BlueTooth scan signal을 받으면 이 함수를 호출해서 idle 타임 초기화
  void signalReceive(pvdSPF) async{
    idleTime = 0;
    if (isConnected == false) {
      // Signal Backend
      isConnected = true;

      await _callEnterAPI(pvdSPF);
      print('signalReceive Notify');
      notifyListeners();
    }
  }
}
