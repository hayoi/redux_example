import 'package:redux/redux.dart';
import 'package:redux_example/redux/student/student_actions.dart';
import 'package:redux_example/redux/student/student_state.dart';

final studentReducer = combineReducers<StudentState>([
  TypedReducer<StudentState, StudentStatusAction>(_studentStatus),
  TypedReducer<StudentState, SyncStudentsAction>(_syncStudents),
  TypedReducer<StudentState, SyncStudentAction>(_syncStudent),
  TypedReducer<StudentState, RemoveStudentAction>(_removeStudent),
]);

StudentState _studentStatus(StudentState state, StudentStatusAction action) {
  var status = state.status ?? Map();
  status.update(action.report.actionName, (v) => action.report,
      ifAbsent: () => action.report);
  return state.copyWith(status: status);
}

StudentState _syncStudents(StudentState state, SyncStudentsAction action) {
  for (var student in action.students) {
    state.students.update(student.id.toString(), (v) => student, ifAbsent: () => student);
  }
  state.page.currPage = action.page.currPage;
  state.page.pageSize = action.page.pageSize;
  state.page.totalCount = action.page.totalCount;
  state.page.totalPage = action.page.totalPage;
  return state.copyWith(students: state.students);
}

StudentState _syncStudent(StudentState state, SyncStudentAction action) {
  state.students.update(action.student.id.toString(), (u) => action.student,
      ifAbsent: () => action.student);
  return state.copyWith(students: state.students, student: action.student);
}

StudentState _removeStudent(StudentState state, RemoveStudentAction action) {
  return state.copyWith(students: state.students..remove(action.id.toString()));
}
