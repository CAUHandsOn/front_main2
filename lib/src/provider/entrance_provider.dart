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
  var _pvdSPF;
  var _classroomName;

  // 맨처음 singnal을 받으면 userProvider에서 정보를 받아서 서버로 전송
  _callEnterAPI() async {
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

      if (_pvdSPF != null){ //학생이면 출입 로그 추가
        _classroomName = jsonDecode(response.body)['data']['room']['name'];
        var getInTime = jsonDecode(response.body)['data']['getIn'];

        if (!_pvdSPF.decodedMap.containsKey(_classroomName)){ //건물 이름이 키로 존재하지 않으면 리스트 생성
          _pvdSPF.decodedMap[_classroomName] = [];
        }
        _pvdSPF.decodedMap[_classroomName]!.add(getInTime); //건물 이름에 맞는 출입 리스트에 항목 추가
        _pvdSPF.saveData('entryLog', _pvdSPF.decodedMap);  //입실 로그 저장
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

        _pvdSPF.decodedMap[_classroomName]!.add(DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now())); //퇴실 시간 추가
        _pvdSPF.saveData('entryLog', _pvdSPF.decodedMap); //퇴실 로그 저장

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
      _pvdSPF = pvdSPF; //받아온 pvdSPF 저장해 두었다가 입실 퇴실 때 로그 저장용으로 사용
      await _callEnterAPI();
      print('signalReceive Notify');
      notifyListeners();
    }
  }
}
