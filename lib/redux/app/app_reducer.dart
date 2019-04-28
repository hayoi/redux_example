import 'package:redux_example/redux/student/student_reducer.dart';
import 'package:redux_example/redux/app/app_state.dart';

///register all the Reducer here
///auto add new reducer when using haystack plugin
AppState appReducer(AppState state, dynamic action) {
  return new AppState(
    studentState: studentReducer(state.studentState, action),

  );
}
