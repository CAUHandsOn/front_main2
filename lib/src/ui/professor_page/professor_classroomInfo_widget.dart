import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/classStudentNumber.dart';
import '../../provider/classroom_provider.dart';

class ProfessorClassroomInfo extends StatefulWidget {
  const ProfessorClassroomInfo({Key? key, this.classroomID, this.classroomName}) : super(key: key);
  final classroomID;
  final classroomName;

  @override
  State<ProfessorClassroomInfo> createState() => _ProfessorClassroomInfo();
}

class _ProfessorClassroomInfo extends State<ProfessorClassroomInfo> {
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
          ),
        ],
      ),
    );
  }

  Widget _body(String classroomID, String classroomName) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ClassroomProvider(),
      builder: (context, child) {
        context.watch<ClassroomProvider>().getStudentClassroomInfo(classroomID);
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
                            '현재 강의실 : $classroomName',
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
                    _headCountWidget(context.watch<ClassroomProvider>().userList.length),
                    const SizedBox(height: 40,),
                    _totalCountWidget(ClassStudentNumber().classStudentNumber[classroomName]!),
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
                    context.watch<ClassroomProvider>().userList.isEmpty
                        ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child : Text("현재 강의실에 참석한 학생이 없습니다", style:
                        TextStyle(fontSize: 20,
                            color: Colors.black),
                        ),),
                    )
                        :ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: context.watch<ClassroomProvider>().userList.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10, bottom: 10),
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
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //headCount값 가져올 수 있게끔 api수정 필요
    return Scaffold(
      appBar: AppBar(
        title: const Text('강의실 정보'),
      ),
      body: _body(widget.classroomID, widget.classroomName),
    );
  }
}
