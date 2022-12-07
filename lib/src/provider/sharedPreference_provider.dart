import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPFProvider with ChangeNotifier{
  dynamic decodedMap = HashMap<String, List<String>>();

  void addLog(String classroomName, String entryType) {
    if (!decodedMap.containsKey(classroomName)){ //건물 이름이 키로 존재하지 않으면 리스트 생성
      decodedMap[classroomName] = <String>[];
    }
    decodedMap[classroomName]!.add('$entryType : ${DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now())}'); //건물 이름에 맞는 출입 리스트에 항목 추가
    saveData('entryLog', decodedMap);
    notifyListeners();
  }

  loadData(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? encodedMap = prefs.getString(key);
    if (encodedMap != null){
      decodedMap = json.decode(encodedMap!);

      print('here is 로드 ${decodedMap}');
    }
    
  }

  saveData(String key, var data) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('save data is $data');
    // HashMap<String, List<String>> entryLog = HashMap<String, List<String>>();
    //
    // entryLog['310관 312호'] = ['2022-11-21T12:23:24.138883963','2022-11-22T12:24:24.138883963', '2022-11-23T12:25:24.138883963'];
    // entryLog['310관 B312호'] = ['2022-11-21T12:23:24.138883963','2022-11-22T12:24:24.138883963', '2022-11-23T12:25:24.138883963'];
    // entryLog['310관 313호'] = ['2022-11-21T12:23:24.138883963','2022-11-22T12:24:24.138883963', '2022-11-23T12:25:24.138883963',
    // '2023-11-25T12:27:24.138883963', '2023-11-26T12:27:24.138883963', '2023-11-27T12:27:24.138883963'];
    // entryLog['310관 B313호'] = ['2022-11-21T12:23:24.138883963','2022-11-22T12:24:24.138883963', '2022-11-23T12:25:24.138883963',
    //     '2023-11-25T12:27:24.138883963', '2023-11-26T12:27:24.138883963', '2023-11-27T12:27:24.138883963'];

    String encodedMap = json.encode(data);
    print('save encoded data is $encodedMap');

    print('here is 저장 $encodedMap');
    prefs.setString(key, encodedMap);
  }

}