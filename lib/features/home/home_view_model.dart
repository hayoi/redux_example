import 'package:redux/redux.dart';
import 'package:redux_example/data/model/photo_data.dart';
import 'package:redux_example/redux/action_report.dart';
import 'package:redux_example/redux/app/app_state.dart';
import 'package:redux_example/redux/photo/photo_actions.dart';

class HomeViewModel {
  final Photo photo;
  final List<Photo> photos;
  final Function(bool) getPhotos;
  final ActionReport getPhotosReport;

  HomeViewModel({
    this.photo,
    this.photos,
    this.getPhotos,
    this.getPhotosReport,
  });

  static HomeViewModel fromStore(Store<AppState> store) {
    return HomeViewModel(
      photo: store.state.photoState.photo,
      photos: store.state.photoState.photos.values.toList() ?? [],
      getPhotos: (isRefresh) {
        store.dispatch(GetPhotosAction(isRefresh: isRefresh));
      },
      getPhotosReport: store.state.photoState.status["GetPhotosAction"],
    );
  }
}
