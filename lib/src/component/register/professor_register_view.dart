import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:handson/src/model/user.dart';

class ProfessorRegisterView extends StatefulWidget {
  const ProfessorRegisterView({Key? key}) : super(key: key);

  @override
  State<ProfessorRegisterView> createState() => _ProfessorRegisterViewState();
}

class _ProfessorRegisterViewState extends State<ProfessorRegisterView> {
  final _formKey = GlobalKey<FormState>();
  String _professorId = '';
  String _name = '';
  String _email = '';
  String _password = '';

  _callRegisterAPI(Map<String,dynamic> data) async{
    String url = 'https://bho.ottitor.shop/auth/sign-up';

    http.Response response = await http.post(
      Uri.parse(url),
      headers: <String,String>{
        'Content-Type' : 'application/json;charset=UTF-8'
      },
      body: jsonEncode(data)
    );
    if (response.statusCode == 200){
      print("callReisterAPI success!");
      return;
    } else{
      print(response.body);
      throw Exception('Failed to Register');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Professor ID',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter professorID';
                }
                return null;
              },
              onSaved: (value) {
                _professorId = value!;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                }
                return null;
              },
              onSaved: (value) {
                _email = value!;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
              onChanged: (value) {
                _password = value!;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password Confirm',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                if (value != _password) {
                  return 'Passwords are not identical';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 60,
            ),
            SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // 회원가입 처리 로직
                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                      // api 통신 처리
                      User data = User(email: _email,id: _professorId,name: _name,password: _password,role: 'professor',accessToken: '');
                      try {
                        _callRegisterAPI(data.toJson());
                      } catch (e){
                        print(e);
                      }
                      Navigator.pop(context, '회원가입이 완료되었습니다.');
                    }

                  },
                  child: const Text('회원가입'),
                ))
          ],
        ),
      ),
    );
  }
}
