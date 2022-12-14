import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:handson/src/model/user.dart';
import 'package:handson/src/provider/bottom_navigation_provider.dart';
import 'package:handson/src/provider/user_provider.dart';
import 'package:handson/src/ui/student_page/student_classroom_widget.dart';
import 'package:handson/src/ui/student_page/student_mypage_widget.dart';
import 'package:handson/src/ui/student_page/student_realtime_widget.dart';
import 'package:provider/provider.dart';

import '../../provider/button_provider.dart';
import '../../provider/classroom_provider.dart';
import '../../provider/entrance_provider.dart';
import '../../provider/sharedPreference_provider.dart';

class StudentWidget extends StatefulWidget {
  StudentWidget({Key? key, required this.user}) : super(key: key);
  late User user;
  @override
  State<StudentWidget> createState() => _StudentWidgetState();
}

class _StudentWidgetState extends State<StudentWidget> {
  late UserProvider _userProvider;
  late BottomNavigationProvider _bottomNavigationProvider;
  late EntranceProvider _entranceProvider;
  late ButtonProvider _buttonProvider;

  Widget _bottomNavigationBarWidget() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '실시간 인원',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: '강의실'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
      ],
      onTap: (index) {
        _bottomNavigationProvider.updateIndex(index);
        if (_buttonProvider.currentEditButton == 1) {
          _buttonProvider.updateEditButton(0);
        }
      },
      currentIndex: _bottomNavigationProvider.currentNavigationIndex,
    );
  }

  Widget _navigationBodyWidget() {
    switch (_bottomNavigationProvider.currentNavigationIndex) {
      case 0:
        return const StudentRealtimeWidget();
      case 1:
        return StudentClassroomWidget();
      case 2:
        return const StudentMyPageWidget();
      default:
        return Container();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _userProvider.initUser(widget.user.name, widget.user.email, widget.user.id,
        widget.user.role, widget.user.accessToken);
    _entranceProvider = context.read<EntranceProvider>();
    _entranceProvider.initTimer(context.read<SPFProvider>());
    startBluetooth();
  }

  void startBluetooth() {
    List<Uuid> services = [];
    List<String> filtered_id = [
      '34:14:B5:41:C6:82',
      '34:14:B5:41:A2:7E',
    ];
    List<String> deviceList = ['LE_WF-1000XM4', 'Buds2', '44:F0:9E:9B:E8:24'];
    log('Scanning device start');
    final flutterReactiveBle = FlutterReactiveBle();
    flutterReactiveBle
        .scanForDevices(withServices: services, scanMode: ScanMode.lowLatency)
        .listen((device) {
      // print(
      //     'Scanning ! ${device.id} : ${device.name} : ${device.serviceUuids}');
      // code for handling results
      if (deviceList.contains(device.name)) {
        print(
            'Discover ! ${device.id} : ${device.name} : ${device.serviceUuids}');
        _entranceProvider.signalReceive(context.read<SPFProvider>(), device.name);
        //sleep(const Duration(seconds:3));
      }
    }, onError: (Object error) {
      //code for handling error
      log('블루투스 스캐닝 에러');
      log(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build: StudentHomeWidget");
    _bottomNavigationProvider = Provider.of<BottomNavigationProvider>(context);
    _buttonProvider = Provider.of<ButtonProvider>(context);
    _entranceProvider = context.watch<EntranceProvider>();
    //startBluetooth();
    return Scaffold(
      body: _navigationBodyWidget(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }
}
