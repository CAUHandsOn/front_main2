import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:handson/src/provider/sharedPreference_provider.dart';
import 'package:handson/src/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EntranceProvider extends ChangeNotifier {
  int idleTime = 0;
  bool isConnected = false;
  bool isInited = false;
  static late String deviceId = '34:14:B5:41:A2:7E';
  var _classroomName;

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
        var classroomName = jsonDecode(response.body)['data']['room']['name'] as String;
        _classroomName = classroomName;

        pvdSPF.addLog(classroomName, '입실');

        // if (!pvdSPF.decodedMap.containsKey(classroomName)){ //건물 이름이 키로 존재하지 않으면 리스트 생성
        //   pvdSPF.decodedMap[classroomName] = <String>[];
        // }
        // pvdSPF.decodedMap[_classroomName]!.add(getInTime); //건물 이름에 맞는 출입 리스트에 항목 추가
        // pvdSPF.saveData('entryLog', pvdSPF.decodedMap);  //입실 로그 저장
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
  void initTimer(pvdSPF) {
    if (isInited) {
      return;
    }
    isInited = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      idleTime++;
      print(idleTime);
      if (idleTime >= 5 && isConnected == true) {
        isConnected = false;
        _callExitAPI();

        if (pvdSPF != null){  //퇴장 시 퇴실로그 저장
          pvdSPF.addLog(_classroomName, '퇴실'); //퇴실 시간 추가
          // pvdSPF.decodedMap[_classroomName]!.add(DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now())); //퇴실 시간 추가
          // pvdSPF.saveData('entryLog', pvdSPF.decodedMap); //퇴실 로그 저장
        }

        print('initTimer Notify');
        notifyListeners();
      }
    });
  }

  // BlueTooth scan signal을 받으면 이 함수를 호출해서 idle 타임 초기화
  void signalReceive(pvdSPF, deviceName) async{
    print("signalReceive");
    idleTime = 0;
    if (isConnected == false) {
      // Signal Backend
      isConnected = true;

      if (deviceName == 'LE_WF-1000XM4') {
        deviceId = '34:14:B5:41:A2:7E';
      } else if (deviceName == 'Buds2'){
        deviceId = 'sajf34k2rl2332rwf213';
      }

      await _callEnterAPI(pvdSPF);
      print('signalReceive Notify');
      notifyListeners();
    }
  }
}
