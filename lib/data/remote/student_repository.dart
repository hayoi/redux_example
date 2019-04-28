import 'dart:async';
import 'package:dio/dio.dart';
import 'package:redux_example/data/model/student_data.dart';
import 'package:redux_example/data/network_common.dart';

class StudentRepository {
  const StudentRepository();

  Future<Map> getStudentsList(String sorting, int page, int limit) {
    return new NetworkCommon().dio.get("student/", queryParameters: {
      "sorting": sorting,
      "page": page,
      "limit": limit
    }).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return results;
    });
  }

  Future<Student> createStudent(Student student) {
    var dio = new NetworkCommon().dio;
    dio.options.headers.putIfAbsent("Accept", () {
      return "application/json";
    });
    return dio.post("student/", data: student).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return new Student.fromJson(results);
    });
  }

  Future<Student> updateStudent(Student student) {
    var dio = new NetworkCommon().dio;
    dio.options.headers.putIfAbsent("Accept", () {
      return "application/json";
    });
    return dio.put("student/", data: student).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return new Student.fromJson(results);
    });
  }

  Future<int> deleteStudent(int id) {
    return new NetworkCommon().dio.delete("student/", queryParameters: {"id": id}).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return id;
    });
  }

  Future<Student> getStudent(int id) {
    return new NetworkCommon().dio.get("student/", queryParameters: {"id": id}).then((d) {
      var results = new NetworkCommon().decodeResp(d);

      return new Student.fromJson(results);
    });
  }

}
