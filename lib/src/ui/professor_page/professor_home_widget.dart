import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:handson/src/model/user.dart';
import 'package:handson/src/provider/bottom_navigation_provider.dart';
import 'package:handson/src/provider/classroom_provider.dart';
import 'package:handson/src/provider/user_provider.dart';
import 'package:handson/src/ui/professor_page/prefessor_mypage_widget.dart';
import 'package:handson/src/ui/professor_page/professor_classroom_widget.dart';
import 'package:handson/src/ui/professor_page/professor_realtime_widget.dart';
import 'package:provider/provider.dart';

import '../../provider/entrance_provider.dart';

class ProfessorWidget extends StatefulWidget {
  ProfessorWidget({Key? key, required this.user}) : super(key: key);

  late User user;

  @override
  State<ProfessorWidget> createState() => _ProfessorWidgetState();
}

class _ProfessorWidgetState extends State<ProfessorWidget> {
  late UserProvider _userProvider;
  late BottomNavigationProvider _bottomNavigationProvider;
  late EntranceProvider _entranceProvider;

  Widget _bottomNavigationBarWidget() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '실시간 인원',),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: '강의실'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
      ],
      onTap: (index) {
        _bottomNavigationProvider.updateIndex(index);
      },
      currentIndex: _bottomNavigationProvider.currentNavigationIndex,
    );
  }

  Widget _navigationBodyWidget() {
    switch (_bottomNavigationProvider.currentNavigationIndex) {
      case 0:
        return ProfessorRealtimeWidget();
      case 1:
        return ProfessorClassroomWidget();
      case 2:
        return ProfessorMyPageWidget();
      default:
        return Container();
    }
  }

  @override
  void initState() {
    print("professor_home_initstate called");
    // TODO: implement initState
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _userProvider.initUser(widget.user.name, widget.user.email, widget.user.id, widget.user.role, widget.user.accessToken);
    _entranceProvider = context.read<EntranceProvider>();
    _entranceProvider.initTimer();
  }

  void startBluetooth() {
    print("startBluetooth");
    _entranceProvider = context.read<EntranceProvider>();
    _bottomNavigationProvider = Provider.of<BottomNavigationProvider>(context);
    List<Uuid> services = [];
    List<String> filtered_id = [
      '34:14:B5:41:C6:82',
      '34:14:B5:41:A2:7E',
    ];
    final flutterReactiveBle = FlutterReactiveBle();
    flutterReactiveBle
        .scanForDevices(withServices: services, scanMode: ScanMode.lowLatency)
        .listen((device) {
      if (!filtered_id.contains(device.id)) {
        if (device.name == 'LE_WF-1000XM4') {
          print(
              'Discover ! ${device.id} : ${device.name} : ${device.serviceUuids}');
          _entranceProvider.signalReceive(null);
        }
      }
    }, onError: (Object error) {
      //code for handling error
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build : professor_home_widget");
    startBluetooth();

    return Scaffold(
      body: _navigationBodyWidget(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }
}
