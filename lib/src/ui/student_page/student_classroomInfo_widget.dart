import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:handson/src/provider/sharedPreference_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/classStudentNumber.dart';
import '../../provider/classroom_provider.dart';

class StudentClassroomInfo extends StatefulWidget {
  const StudentClassroomInfo({Key? key, this.classroomID, this.classroomName}) : super(key: key);
  final classroomID;
  final classroomName;

  @override
  State<StudentClassroomInfo> createState() => _StudentClassroomInfoState();
}

class _StudentClassroomInfoState extends State<StudentClassroomInfo> {
  var _switchValue = false;

  // HashMap --> entryList[건물 이름] = List of 출입 기록
  // HashMap을 DB에 load 및 save 할 필요 (새로운 출입 생길 시 update 필요)

  // HashMap<String, List<String>> entryLog = HashMap<String, List<String>>();
  // List<String> entry = List.empty(growable: true);

  @override
  void initState(){
    super.initState();
  }

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

  Widget _info(String classroomID, String classroomName){
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

  Widget _entryLog(String classroomName) {
    return Consumer<SPFProvider>(
        builder: (context, provider, widget) {
          print('Shared Preference 데이터 값 : ${provider.decodedMap}');
          return Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '현재 강의실 $classroomName',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 18),
                            ),
                            Row(
                              children: [
                                const Text(
                                  '내역 지우기',
                                  style: TextStyle(fontWeight: FontWeight.w400,
                                      fontSize: 18),
                                ),
                                Switch(
                                    value: _switchValue,
                                    onChanged: (value) {
                                      setState(() {
                                        _switchValue = value;
                                      });
                                    }),
                              ],
                            ),
                          ],
                        ),
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
                            child: Text('현재 시간 : ${DateFormat(
                                'yyyy-MM-dd kk:mm').format(DateTime.now())}',
                              style: const TextStyle(color: Colors.black),),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40,),

                      (provider.decodedMap == null || provider.decodedMap[classroomName] == null || provider.decodedMap[classroomName]!.isEmpty)
                          ? const Padding( //비어 있으면
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text("강의실에 참석한 기록이 없습니다", style:
                          TextStyle(fontSize: 20,
                              color: Colors.black),
                          ),),
                      )
                          : _switchValue //비어 있지 않으며 내역 지우기가 활성화 일 시
                          ? ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.decodedMap[classroomName]!.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: ValueKey(provider.decodedMap[classroomName]![index]),
                            direction: DismissDirection.startToEnd,
                            //왼쪽에서 오른쪽으로 스와이프
                            onDismissed: (direction) { //값을 완전히 삭제
                              setState(() {
                                if (direction == DismissDirection.startToEnd) {
                                  print('길이 ${provider.decodedMap[classroomName]!.length}');
                                  provider.decodedMap[classroomName]!.removeAt(index);
                                  provider.saveData('example', provider.decodedMap); //삭제할 때마다 SPF에 데이터 새로 저장
                                }
                              });
                            },
                            child: ListTile(
                              title: Text('${provider.decodedMap[classroomName]![index]}'),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context,
                            int index) => const Divider(thickness: 1),
                      )
                          : ListView.separated( //비어 있지 않으며 내역 지우기가 비활성화 일 시
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.decodedMap[classroomName]!.length,
                        itemBuilder: (context, index) =>
                            ListTile(
                              title: Text(provider.decodedMap[classroomName]![index],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                        separatorBuilder: (BuildContext context,
                            int index) => const Divider(thickness: 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('강의실'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '정보'),
              Tab(text: '출입 내역'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Tab(
              child : _info(widget.classroomID, widget.classroomName),
            ),
            Tab(
              child : _entryLog(widget.classroomName),
            ),
          ],
        )
      ),
    );
  }
}


