import 'package:meta/meta.dart';
import 'package:redux_example/data/model/student_data.dart';
import 'package:redux_example/redux/action_report.dart';
import 'package:redux_example/data/model/page_data.dart';

class GetStudentsAction {
  final String actionName = "GetStudentsAction";
  final bool isRefresh;

  GetStudentsAction({this.isRefresh});
}

class GetStudentAction {
  final String actionName = "GetStudentAction";
  final int id;

  GetStudentAction({@required this.id});
}

class StudentStatusAction {
  final String actionName = "StudentStatusAction";
  final ActionReport report;

  StudentStatusAction({@required this.report});
}

class SyncStudentsAction {
  final String actionName = "SyncStudentsAction";
  final Page page;
  final List<Student> students;

  SyncStudentsAction({this.page, this.students});
}

class SyncStudentAction {
  final String actionName = "SyncStudentAction";
  final Student student;

  SyncStudentAction({@required this.student});
}

class CreateStudentAction {
  final String actionName = "CreateStudentAction";
  final Student student;

  CreateStudentAction({@required this.student});
}

class UpdateStudentAction {
  final String actionName = "UpdateStudentAction";
  final Student student;

  UpdateStudentAction({@required this.student});
}

class DeleteStudentAction {
  final String actionName = "DeleteStudentAction";
  final Student student;

  DeleteStudentAction({@required this.student});
}

class RemoveStudentAction {
  final String actionName = "RemoveStudentAction";
  final int id;

  RemoveStudentAction({@required this.id});
}

