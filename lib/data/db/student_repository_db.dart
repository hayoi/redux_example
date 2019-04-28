import 'dart:async';

import 'package:redux_example/data/model/student_data.dart';
import 'package:redux_example/data/db/database_client.dart';
import 'package:sqflite/sqflite.dart';

class StudentRepositoryDB {
  const StudentRepositoryDB();

  Future<List<Student>> getStudentsList(String sorting, int limit, int skipCount) async {
    Database db = await DatabaseClient().db;
    List<Map> results = await db.query("student", limit: limit, offset: skipCount, orderBy: "${sorting} DESC");

    List<Student> students = new List();
    results.forEach((result) {
      Student student = Student.fromMap(result);
      students.add(student);
    });
    return students;
  }

  Future<Student> createStudent(Student student) async {
    try {
      var count = 0;
      Database db = await DatabaseClient().db;
      if (student.id != null) {
        count = Sqflite.firstIntValue(await db
            .rawQuery("SELECT COUNT(*) FROM student WHERE id = ?", [student.id]));
      }
      if (count == 0) {
        student.id = await db.insert("student", student.toMap());
      } else {
        await db.update("student", student.toMap(),
            where: "id = ?", whereArgs: [student.id]);
      }
    } catch (e) {
      print(e.toString());
    }
    return student;
  }

  Future<int> deleteStudent(int id) async {
    Database db = await DatabaseClient().db;
    return db.delete("student", where: "id = ?", whereArgs: [id]);
  }

  Future<Student> getStudent(int id) async {
    Database db = await DatabaseClient().db;
    List<Map> results =
        await db.query("student", where: "id = ?", whereArgs: [id]);
    Student student = Student.fromMap(results[0]);
    return student;
  }

  Future<Student> updateStudent(Student student) async {
    Database db = await DatabaseClient().db;
    var count = Sqflite.firstIntValue(await db
        .rawQuery("SELECT COUNT(*) FROM student WHERE id = ?", [student.id]));
    if (count == 0) {
      student.id = await db.insert("student", student.toMap());
    } else {
      await db.update("student", student.toMap(),
          where: "id = ?", whereArgs: [student.id]);
    }
    return student;
  }

}