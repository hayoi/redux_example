import 'package:redux/redux.dart';
import 'package:redux_example/data/model/student_data.dart';
import 'package:redux_example/redux/action_report.dart';
import 'package:redux_example/redux/app/app_state.dart';
import 'package:redux_example/redux/student/student_actions.dart';

class HomeViewModel {
  final Student student;
  final List<Student> students;
  final Function(bool) getStudents;
  final ActionReport getStudentsReport;
  final Function(Student) deleteStudent;
  final ActionReport deleteStudentReport;

  HomeViewModel({
    this.student,
    this.students,
    this.getStudents,
    this.getStudentsReport,
    this.deleteStudent,
    this.deleteStudentReport,
  });

  static HomeViewModel fromStore(Store<AppState> store) {
    return HomeViewModel(
      student: store.state.studentState.student,
      students: store.state.studentState.students.values.toList() ?? [],
      getStudents: (isRefresh) {
        store.dispatch(GetStudentsAction(isRefresh: isRefresh));
      },
      getStudentsReport: store.state.studentState.status["GetStudentsAction"],
      deleteStudent: (student) {
        store.dispatch(DeleteStudentAction(student: student));
      },
      deleteStudentReport: store.state.studentState.status["DeleteStudentAction"],
    );
  }
}
