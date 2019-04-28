import 'package:redux_example/redux/student/student_middleware.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_example/redux/app/app_state.dart';
import 'package:redux_example/redux/app/app_reducer.dart';

Future<Store<AppState>> createStore() async {
  return Store(
    appReducer,
    initialState: AppState.initial(),
    middleware: []
      ..addAll(createStudentMiddleware())
      ..addAll([
        LoggingMiddleware<dynamic>.printer(level: Level.ALL),
      ]),
  );
}