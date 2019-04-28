import 'package:meta/meta.dart';
import 'package:redux_example/data/model/student_data.dart';
import 'package:redux_example/data/model/page_data.dart';
import 'package:redux_example/redux/action_report.dart';

class StudentState {
  final Map<String, Student> students;
  final Student student;
  final Map<String, ActionReport> status;
  final Page page;

  StudentState({
    @required this.students,
    @required this.student,
    @required this.status,
    @required this.page,
  });

  StudentState copyWith({
    Map<String, Student> students,
    Student student,
    Map<String, ActionReport> status,
    Page page,
  }) {
    return StudentState(
      students: students ?? this.students ?? Map(),
      student: student ?? this.student,
      status: status ?? this.status,
      page: page ?? this.page,
    );
  }
}
