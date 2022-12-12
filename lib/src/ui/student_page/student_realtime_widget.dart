import 'package:flutter/material.dart';
import 'package:handson/src/model/classroom.dart';
import 'package:handson/src/provider/classroom_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/entrance_provider.dart';
import '../../provider/user_provider.dart';

class StudentRealtimeWidget extends StatefulWidget {
  const StudentRealtimeWidget({Key? key}) : super(key: key);

  @override
  State<StudentRealtimeWidget> createState() => _StudentRealtimeWidgetState();
}

class _StudentRealtimeWidgetState extends State<StudentRealtimeWidget> {
  Widget _headCountWidget(int headCount) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "실시간 인원",
            style: TextStyle(fontSize: 16),
          ),
          Text(
            '$headCount명',
            style: const TextStyle(fontSize: 50, color: Colors.indigo),
          )
        ],
      ),
    );
  }

  Widget _totalCountWidget(int totalCount) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "수강 정원",
            style: TextStyle(fontSize: 16),
          ),

          Text(
            '$totalCount명',
            style: const TextStyle(fontSize: 50, color: Colors.indigo),
          )
        ],
      ),
    );
  }

  Widget connectedView(){
    context.read<ClassroomProvider>().callRoomInfoAPI();
    if (context.watch<ClassroomProvider>().isLoaded){
      var classroom = context.read<ClassroomProvider>().classroomInfo;
      return Padding(
        padding: const EdgeInsets.only(top: 16,left: 16,right: 16),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10,left: 14),
                        child: Text(
                          '현재 강의실 : ${classroom.name}',
                          textAlign: TextAlign.start,
                          style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    endIndent: 10,
                    indent: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Text('현재 시간 : ${DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now())}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40,),
                  _headCountWidget(classroom.studentList.length),
                  const SizedBox(height: 40,),
                  _totalCountWidget(20),
                  const SizedBox(height: 40,),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(top: 10,left: 14),
                        child: Text(
                          '실시간 참석자 명단',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    endIndent: 10,
                    indent: 10,
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: classroom.studentList.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10,right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.id,
                                style: const TextStyle(
                                    fontSize: 16
                                )),
                            Text(item.name,
                              style: const TextStyle(
                                  fontSize: 16
                              ),),
                          ],
                        ),
                      );

                    }).toList(),
                  )
                ],

              ),
            )
          ],
        ),
      );
    }
    else{
      return const Center(child: CircularProgressIndicator(),);
    }
  }

  Widget disConnectedView(){
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        width: 326,
        height: 374,
        child: Column(
          children: [
            const SizedBox(height: 20,),
            const Text("현재 위치한 강의실이 없습니다.",textAlign: TextAlign.start,style: TextStyle(fontSize: 20),),
            const SizedBox(height: 50,),
            Text('학번: ${context.read<UserProvider>().id}',style: TextStyle(fontSize: 30),textAlign: TextAlign.start,),
            Text('이름 : ${context.read<UserProvider>().name}',style: TextStyle(fontSize: 30),textAlign: TextAlign.start,),
            const SizedBox(height: 150,),
            const Text("현재시간",textAlign: TextAlign.center),
            Text(DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()),textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
          ],
        ),
      ),

    );
  }


  @override
  Widget build(BuildContext context) {
    print("build : student_realtime_widget");
    return Scaffold(
      appBar: AppBar(
        title: const Text('실시간 인원 - 학생'),
      ),
      body: context.watch<EntranceProvider>().isConnected
          ? connectedView() : disConnectedView(),
      backgroundColor: Colors.grey.withOpacity(0.25),
    );
  }
}
