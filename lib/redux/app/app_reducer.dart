import 'package:redux_example/redux/photo/photo_reducer.dart';
import 'package:redux_example/redux/app/app_state.dart';

///register all the Reducer here
///auto add new reducer when using haystack plugin
AppState appReducer(AppState state, dynamic action) {
  return new AppState(
    photoState: photoReducer(state.photoState, action),

  );
}
