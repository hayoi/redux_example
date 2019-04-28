import 'package:redux/redux.dart';
import 'package:redux_example/redux/action_report.dart';
import 'package:redux_example/redux/app/app_state.dart';
import 'package:redux_example/redux/student/student_actions.dart';
import 'package:redux_example/data/model/student_data.dart';
import 'package:redux_example/data/remote/student_repository.dart';
import 'package:redux_example/data/db/student_repository_db.dart';
import 'package:redux_example/redux/student/student_actions.dart';
import 'package:redux_example/data/model/page_data.dart';

List<Middleware<AppState>> createStudentMiddleware([
  StudentRepository _repository = const StudentRepository(),
  StudentRepositoryDB _repositoryDB = const StudentRepositoryDB(),
]) {
  final getStudent = _createGetStudent(_repository, _repositoryDB);
  final getStudents = _createGetStudents(_repository, _repositoryDB);
  final createStudent = _createCreateStudent(_repository, _repositoryDB);
  final updateStudent = _createUpdateStudent(_repository, _repositoryDB);
  final deleteStudent = _createDeleteStudent(_repository, _repositoryDB);

  return [
    TypedMiddleware<AppState, GetStudentAction>(getStudent),
    TypedMiddleware<AppState, GetStudentsAction>(getStudents),
    TypedMiddleware<AppState, CreateStudentAction>(createStudent),
    TypedMiddleware<AppState, UpdateStudentAction>(updateStudent),
    TypedMiddleware<AppState, DeleteStudentAction>(deleteStudent),
  ];
}


Middleware<AppState> _createGetStudent(
    StudentRepository repository, StudentRepositoryDB repositoryDB) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action.id == null) {
      idEmpty(next, action);
    } else {
      running(next, action);
      repository.getStudent(action.id).then((item) {
        next(SyncStudentAction(student: item));
        completed(next, action);
      }).catchError((error) {
        catchError(next, action, error);
      });
    }
  };
}

Middleware<AppState> _createGetStudents(
    StudentRepository repository, StudentRepositoryDB repositoryDB) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    if (action.isRefresh) {
      store.state.studentState.page.currPage = 1;
      store.state.studentState.students.clear();
    } else {
      var p = ++store.state.studentState.page.currPage;
      if (p > ++store.state.studentState.page.totalPage) {
        noMoreItem(next, action);
        return;
      }
    }
    repository
        .getStudentsList(
            "id",
            store.state.studentState.page.currPage,
            store.state.studentState.page.pageSize)
        .then((map) {
      if (map.isNotEmpty) {
        var page = Page(
            currPage: map["currPage"],
            totalPage: map["totalPage"],
            totalCount: map["totalCount"]);
        var l = map["list"] ?? List();
        List<Student> list =
            l.map<Student>((item) => new Student.fromJson(item)).toList();
        next(SyncStudentsAction(page: page, students: list));
      }
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
//    repositoryDB
//        .getStudentsList(
//            "id",
//            store.state.studentState.page.pageSize,
//            store.state.studentState.page.pageSize *
//                store.state.studentState.page.currPage)
//        .then((map) {
//      if (map.isNotEmpty) {
//        var page = Page(currPage: store.state.studentState.page.currPage + 1);
//        next(SyncStudentsAction(page: page, students: map));
//        completed(next, action);
//      }
//    }).catchError((error) {
//      catchError(next, action, error);
//    });
  };
}

Middleware<AppState> _createCreateStudent(
    StudentRepository repository, StudentRepositoryDB repositoryDB) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.createStudent(action.student).then((item) {
      next(SyncStudentAction(student: item));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _createUpdateStudent(
    StudentRepository repository, StudentRepositoryDB repositoryDB) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.updateStudent(action.student).then((item) {
      next(SyncStudentAction(student: item));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _createDeleteStudent(
    StudentRepository repository, StudentRepositoryDB repositoryDB) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.deleteStudent(action.student.id).then((item) {
      next(RemoveStudentAction(id: action.student.id));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

void catchError(NextDispatcher next, action, error) {
  next(StudentStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.error,
          msg: "${action.actionName} is error;${error.toString()}")));
}

void completed(NextDispatcher next, action) {
  next(StudentStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.complete,
          msg: "${action.actionName} is completed")));
}

void noMoreItem(NextDispatcher next, action) {
  next(StudentStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.complete,
          msg: "no more items")));
}

void running(NextDispatcher next, action) {
  next(StudentStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.running,
          msg: "${action.actionName} is running")));
}

void idEmpty(NextDispatcher next, action) {
  next(StudentStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.error,
          msg: "Id is empty")));
}
