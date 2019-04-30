import 'package:redux/redux.dart';
import 'package:redux_example/redux/action_report.dart';
import 'package:redux_example/redux/app/app_state.dart';
import 'package:redux_example/redux/photo/photo_actions.dart';
import 'package:redux_example/data/model/photo_data.dart';
import 'package:redux_example/data/remote/photo_repository.dart';
import 'package:redux_example/redux/photo/photo_actions.dart';
import 'package:redux_example/data/model/page_data.dart';

List<Middleware<AppState>> createPhotoMiddleware([
  PhotoRepository _repository = const PhotoRepository(),
]) {
  final getPhoto = _createGetPhoto(_repository);
  final getPhotos = _createGetPhotos(_repository);
  final createPhoto = _createCreatePhoto(_repository);
  final updatePhoto = _createUpdatePhoto(_repository);
  final deletePhoto = _createDeletePhoto(_repository);

  return [
    TypedMiddleware<AppState, GetPhotoAction>(getPhoto),
    TypedMiddleware<AppState, GetPhotosAction>(getPhotos),
    TypedMiddleware<AppState, CreatePhotoAction>(createPhoto),
    TypedMiddleware<AppState, UpdatePhotoAction>(updatePhoto),
    TypedMiddleware<AppState, DeletePhotoAction>(deletePhoto),
  ];
}


Middleware<AppState> _createGetPhoto(
    PhotoRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action.id == null) {
      idEmpty(next, action);
    } else {
      running(next, action);
      repository.getPhoto(action.id).then((item) {
        next(SyncPhotoAction(photo: item));
        completed(next, action);
      }).catchError((error) {
        catchError(next, action, error);
      });
    }
  };
}

Middleware<AppState> _createGetPhotos(
    PhotoRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    if (action.isRefresh) {
      store.state.photoState.page.currPage = 1;
      store.state.photoState.photos.clear();
    } else {
      var p = ++store.state.photoState.page.currPage;
      if (p > ++store.state.photoState.page.totalPage) {
        noMoreItem(next, action);
        return;
      }
    }
    repository
        .getPhotosList(
        "sorting",
        store.state.photoState.page.currPage,
        store.state.photoState.page.pageSize)
        .then((map) {
      if (map.isNotEmpty) {

        next(SyncPhotosAction(page: Page(), photos: map));
      }
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
//    repositoryDB
//        .getPhotosList(
//            "id",
//            store.state.photoState.page.pageSize,
//            store.state.photoState.page.pageSize *
//                store.state.photoState.page.currPage)
//        .then((map) {
//      if (map.isNotEmpty) {
//        var page = Page(currPage: store.state.photoState.page.currPage + 1);
//        next(SyncPhotosAction(page: page, photos: map));
//        completed(next, action);
//      }
//    }).catchError((error) {
//      catchError(next, action, error);
//    });
  };
}

Middleware<AppState> _createCreatePhoto(
    PhotoRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.createPhoto(action.photo).then((item) {
      next(SyncPhotoAction(photo: item));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _createUpdatePhoto(
    PhotoRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.updatePhoto(action.photo).then((item) {
      next(SyncPhotoAction(photo: item));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

Middleware<AppState> _createDeletePhoto(
    PhotoRepository repository) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    running(next, action);
    repository.deletePhoto(action.photo.id).then((item) {
      next(RemovePhotoAction(id: action.photo.id));
      completed(next, action);
    }).catchError((error) {
      catchError(next, action, error);
    });
  };
}

void catchError(NextDispatcher next, action, error) {
  next(PhotoStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.error,
          msg: "${action.actionName} is error;${error.toString()}")));
}

void completed(NextDispatcher next, action) {
  next(PhotoStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.complete,
          msg: "${action.actionName} is completed")));
}

void noMoreItem(NextDispatcher next, action) {
  next(PhotoStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.complete,
          msg: "no more items")));
}

void running(NextDispatcher next, action) {
  next(PhotoStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.running,
          msg: "${action.actionName} is running")));
}

void idEmpty(NextDispatcher next, action) {
  next(PhotoStatusAction(
      report: ActionReport(
          actionName: action.actionName,
          status: ActionStatus.error,
          msg: "Id is empty")));
}
