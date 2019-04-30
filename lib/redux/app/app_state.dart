import 'package:redux_example/redux/photo/photo_state.dart';
import 'package:meta/meta.dart';
import 'package:redux_example/data/model/page_data.dart';

/// manage all state of this project
/// auto add new state when using haystack plugin
/// configure the initialize of state
class AppState {
  final PhotoState photoState;

  AppState({
    @required this.photoState,

  });

  factory AppState.initial() {
    return AppState(
        photoState: PhotoState(
            photo: null,
            photos: Map(),
            status: Map(),
            page: Page(),),

    );
  }
}
