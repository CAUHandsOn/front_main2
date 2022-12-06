import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:handson/src/model/user.dart';
import 'package:handson/src/provider/bottom_navigation_provider.dart';
import 'package:handson/src/provider/button_provider.dart';
import 'package:handson/src/provider/classroomList_provider.dart';
import 'package:handson/src/provider/classroom_provider.dart';
import 'package:handson/src/provider/entrance_provider.dart';
import 'package:handson/src/provider/sharedPreference_provider.dart';
import 'package:handson/src/provider/user_provider.dart';
import 'package:handson/src/ui/professor_page/professor_home_widget.dart';
import 'package:handson/src/ui/register/register_widget.dart';
import 'package:handson/src/ui/student_page/student_home_widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  String _currentEmail = '';
  String _currentPassword = '';
  bool _isIdSaved = false;
  bool _isAutoLogin = false;
  String role = 'professor';

  Future<dynamic> _callLoginAPI(Map<String, dynamic> data) async {
    String url = 'https://bho.ottitor.shop/auth/sign-in';

    http.Response response = await http.post(
      Uri.parse(url),
        headers: <String,String>{
          'Content-Type' : 'application/json;charset=UTF-8'
        },
        body: jsonEncode(data)
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print('login response body');
      print(body);
      return body['data'];
    } else {
      print(response.body);
      throw Exception("Failed Login");
    }
  }

  Widget _loginBody() {
    var logger = Logger();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset('assets/images/logo.png', width: 328)],
            ),
            const SizedBox(
              height: 60,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '사용자 Email을 입력해주세요.',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                _currentEmail = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '사용자 Password를 입력해주세요.',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                _currentPassword = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Password';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: _isIdSaved,
                  onChanged: (value) {
                    setState(() {
                      _isIdSaved = value!;
                    });
                  },
                ),
                const Text('ID저장        '),
                Checkbox(
                  value: _isAutoLogin,
                  onChanged: (value) {
                    setState(() {
                      _isAutoLogin = value!;
                    });
                  },
                ),
                const Text('자동로그인'),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                  onPressed: () async{
                    var pvdSPF = SPFProvider();
                    await pvdSPF.loadData('example');
                    print('loaded pvdSPF is ${pvdSPF.decodedMap}');

                    // 로그인 process
                    if (_formKey.currentState!.validate()) {
                      // 사용자 입력값 1차 검증후 로그인 로직 수행
                      _formKey.currentState!.save();
                      // if (login suceess)

                      var data = Map<String, String>();
                      data['email'] = _currentEmail;
                      data['password'] = _currentPassword;

                      try {
                        _callLoginAPI(data).then((response) {
                          Map<String,dynamic> decodedToken = JwtDecoder.decode(response['accessToken']);
                          User user = User(
                              email: decodedToken['email'],
                              name: decodedToken['name'],
                              password: _currentPassword,
                              role: decodedToken['role'],
                              id: decodedToken['id'],
                              accessToken: response['accessToken']
                          );

                          logger.d('${user.id},${user.email},${user.role}');

                          if (decodedToken['role'] == 'student') {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MultiProvider(providers: [
                                          ChangeNotifierProvider(
                                            create: (BuildContext context) =>
                                                UserProvider(),
                                          ),
                                          ChangeNotifierProvider(
                                            create: (BuildContext context) =>
                                                BottomNavigationProvider(),
                                          ),
                                          ChangeNotifierProvider(
                                            create: (BuildContext context) =>
                                                ClassroomProvider(),
                                          ),
                                          ChangeNotifierProvider(
                                            create: (BuildContext context) =>
                                                EntranceProvider(),
                                          ),
                                          ChangeNotifierProvider(
                                            create: (BuildContext context) =>
                                                ButtonProvider(),
                                          ),
                                          ChangeNotifierProvider(
                                            create: (BuildContext context) =>
                                                ClassroomListProvider(),
                                          ),
                                          ChangeNotifierProvider(
                                            create: (BuildContext context) => pvdSPF,
                                          ),
                                        ], child: StudentWidget(user: user, pvdSPF : pvdSPF))));
                          }
                          if (decodedToken['role'] == 'professor') {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MultiProvider(providers: [
                                          ChangeNotifierProvider(
                                            create: (BuildContext context) =>
                                                UserProvider(),
                                          ),
                                          ChangeNotifierProvider(
                                            create: (BuildContext context) =>
                                                BottomNavigationProvider(),
                                          ),
                                          ChangeNotifierProvider(
                                            create: (BuildContext context) =>
                                                ClassroomProvider(),
                                          ),
                                          ChangeNotifierProvider(
                                            create: (BuildContext context) =>
                                                EntranceProvider(),
                                          ),
                                          ChangeNotifierProvider(
                                            create: (BuildContext context) =>
                                                ButtonProvider(),
                                          ),
                                          ChangeNotifierProvider(
                                            create: (BuildContext context) =>
                                                ClassroomListProvider(),
                                          ),
                                          ChangeNotifierProvider(
                                            create: (BuildContext context) =>
                                                SPFProvider(),
                                          ),
                                        ], child: ProfessorWidget(user: user))));
                          }
                        });
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: const Text("로그인")),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterWidget()));
                    if (result != null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('$result')));
                    }
                  },
                  child: const Text("회원가입")),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('E-ID Bluetooth'),
          backgroundColor: Colors.indigo,
        ),
        body: _loginBody());
  }
}
