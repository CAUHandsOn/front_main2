import 'student.dart';


class Classroom{
  String id;
  String name;
  List<Student> studentList;

  Classroom(
      this.id,
      this.name,
      this.studentList
      );

  Classroom.fromJson(Map<String,dynamic> json):
        id = json['id'] as String,
        name = json['name'] as String,
        studentList = (json['roomMembers'] as List<dynamic>).map((item) => Student.fromJson(item['user'])).toList();

}