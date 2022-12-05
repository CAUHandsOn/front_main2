import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPFProvider with ChangeNotifier{
  HashMap<String, List<String>> decodedMap = HashMap<String, List<String>>();

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
    print('save data is $encodedMap');

    print('here is 저장 $encodedMap');
    prefs.setString(key, encodedMap);
  }

}