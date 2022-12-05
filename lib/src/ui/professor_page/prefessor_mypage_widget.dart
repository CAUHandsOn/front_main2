import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:handson/src/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../provider/button_provider.dart';
import '../home.dart';

class ProfessorMyPageWidget extends StatefulWidget {
  const ProfessorMyPageWidget({Key? key}) : super(key: key);

  @override
  State<ProfessorMyPageWidget> createState() => _ProfessorMyPageWidgetState();
}

class _ProfessorMyPageWidgetState extends State<ProfessorMyPageWidget> {
  late ButtonProvider _buttonProvider;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
  }

  _callPatchAPI(Map<String, dynamic> data, String originalID) async {
    String url = 'https://bho.ottitor.shop/user/me';

    http.Response response = await http.patch(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ${UserProvider.accessToken}',
        'Content-Type': 'application/json;charset=UTF-8'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      Map re = jsonDecode(response.body);
      log(re.toString());

      _userProvider.changeName = re['data']['name'];
      _userProvider.changeEmail = re['data']['email'];
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('변경이 저장되지 않았습니다')));
      throw Exception('Failed to Register');
    }
  }

  Widget myInfo(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '정보',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      child: const Text(
                        '수정하기',
                        style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        _buttonProvider.updateEditButton(1);
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '학번 : ${_userProvider.id}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
                const Divider(
                  endIndent: 5,
                  indent: 5,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '이름 : ${_userProvider.name}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
                const Divider(
                  endIndent: 10,
                  indent: 10,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '이메일 : ${_userProvider.email}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
                const Divider(
                  endIndent: 10,
                  indent: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myPage(context) {
    final _formKey = GlobalKey<FormState>();
    String _newId = '';
    String _newName = '';
    String _newEmail = '';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '정보',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            TextButton(
                              child: const Text(
                                '저장하기',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  var data = <String, dynamic>{};
                                  if (_newName != '' && _newName.isNotEmpty) {
                                    data['name'] = _newName;
                                  }
                                  if (_newEmail != '' && _newEmail.isNotEmpty) {
                                    data['email'] = _newEmail;
                                  }

                                  try {
                                    log("patchAPI 호출 시작");
                                    await _callPatchAPI(
                                        data, _userProvider.originalID[0]);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('변경이 저장되었습니다')));
                                    _buttonProvider.updateEditButton(0);
                                  } on Exception {
                                    print('error');
                                  }
                                }
                              },
                            ),
                            const Text(
                              '/',
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              child: const Text(
                                '취소',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                _buttonProvider.updateEditButton(0);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '학번 : ${_userProvider.id}',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: '이름',
                      hintText: _userProvider.name,
                      border: const OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _newName = value!;
                    },
                    validator: (value) {
                      // if (value == null || value.isEmpty) {
                      //   return 'Please enter Name';
                      // }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: '이메일',
                      hintText: _userProvider.email,
                      border: const OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _newEmail = value!;
                    },
                    validator: (value) {
                      // if (value == null || value.isEmpty) {
                      //   return 'Please enter Email';
                      // }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context);
    _buttonProvider = Provider.of<ButtonProvider>(context);
    _userProvider.originalID.add(_userProvider.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
      ),
      body: _buttonProvider.currentEditButton == 0
          ? myInfo(context)
          : myPage(context),
      backgroundColor: Colors.grey.withOpacity(0.25),
    );
  }
}
