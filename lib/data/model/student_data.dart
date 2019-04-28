import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class Student {
  DateTime birthday;
  String name;
  List<String> course;
  int id;
  int age;
  bool status;

  Student({
    this.birthday,
    this.name = "",
    this.course,
    this.id = 0,
    this.age = 0,
    this.status = false,
  });

  Student.fromJson(Map<String, dynamic>  map) :
        birthday = map['birthday'] == null ? null
               : DateTime.parse(map["birthday"]),
        name = map['name']  ?? "",
        course = map['course'] == null
            ? []
            : map['course'].cast<String>().toList(),
        id = map['id']  ?? 0,
        age = map['age']  ?? 0,
        status = map['status']  ?? false;

  Map<String, dynamic> toJson() => {
        'birthday': birthday == null? null
               : DateFormat('yyyy-MM-dd HH:mm:ss').format(birthday),
        'name': name,
        'course': course,
        'id': id,
        'age': age,
        'status': status,
      };

  Student copyWith({
    DateTime birthday,
    String name,
    List<String> course,
    int id,
    int age,
    bool status,
  }) {
    return Student(
      birthday: birthday ?? this.birthday,
      name: name ?? this.name,
      course: course ?? this.course,
      id: id ?? this.id,
      age: age ?? this.age,
      status: status ?? this.status,
    );
  }

  static Future createTable(Database db) async {
    db.execute("""
            CREATE TABLE IF NOT EXISTS student (
              birthday TEXT,
              name TEXT,
              course ,
              id INTEGER PRIMARY KEY,
              age INTEGER,
              status INTEGER 
            )""");}

  Student.fromMap(Map<String, dynamic>  map) :
        birthday = map['birthday'] == null? null
               : DateTime.parse(map["birthday"]),
        name = map['name'],
        course = json.decode(map['course']),
        id = map['id'],
        age = map['age'],
        status = (map['status'] == 1);

  Map<String, dynamic> toMap() => {
        'birthday': birthday == null? null
               : DateFormat('yyyy-MM-dd HH:mm:ss').format(birthday),
        'name': name,
        'course': course.toString(),
        'id': id,
        'age': age,
        'status': (status == true)?1:0,
      };

}

