import 'package:redux_example/redux/student/student_state.dart';
import 'package:meta/meta.dart';
import 'package:redux_example/data/model/page_data.dart';

/// manage all state of this project
/// auto add new state when using haystack plugin
/// configure the initialize of state
class AppState {
  final StudentState studentState;

  AppState({
    @required this.studentState,

  });

  factory AppState.initial() {
    return AppState(
        studentState: StudentState(
            student: null,
            students: Map(),
            status: Map(),
            page: Page(),),

    );
  }
}
