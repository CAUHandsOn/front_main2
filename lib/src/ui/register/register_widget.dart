import 'package:flutter/material.dart';
import 'package:handson/src/component/register/professor_register_view.dart';
import 'package:handson/src/component/register/student_register_view.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({Key? key}) : super(key: key);

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('회원가입'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: '학생',
              ),
              Tab(
                text: '교수',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Tab(child: StudentRegisterView(),),
            Tab(child: ProfessorRegisterView(),),
          ],
        )
      ),
    );
  }
}
