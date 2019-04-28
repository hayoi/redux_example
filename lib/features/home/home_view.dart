import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redux_example/data/model/student_data.dart';
import 'package:redux_example/data/model/choice_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redux_example/trans/translations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_example/redux/app/app_state.dart';
import 'package:redux_example/features/home/home_view_model.dart';
import 'package:redux_example/redux/action_report.dart';
import 'package:redux_example/utils/progress_dialog.dart';
import 'package:redux_example/features/widget/swipe_list_item.dart';

class HomeView extends StatelessWidget {
  HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeViewModel>(
      distinct: true,
      converter: (store) => HomeViewModel.fromStore(store),
      builder: (_, viewModel) => HomeViewContent(
            viewModel: viewModel,
          ),
    );
  }
}

class HomeViewContent extends StatefulWidget {
  final HomeViewModel viewModel;

  HomeViewContent({Key key, this.viewModel}) : super(key: key);

  @override
  _HomeViewContentState createState() => _HomeViewContentState();
}

class _HomeViewContentState extends State<HomeViewContent> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final TrackingScrollController _scrollController = TrackingScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var dpr;


  @override
  void initState() {
    super.initState();
    if (this.widget.viewModel.students.length == 0) {
      this.widget.viewModel.getStudents(true);
    }
  }
  


  @override
  void didUpdateWidget(HomeViewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, () {

      if (this.widget.viewModel.deleteStudentReport?.status ==
          ActionStatus.running) {
        if (dpr == null) {
          dpr = new ProgressDialog(context);
        }
        dpr.setMessage("Deleting...");
        dpr.show();
      } else {
        if (dpr != null && dpr.isShowing()) {
          dpr.hide();
          dpr = null;
        }
      }
    });
  }

  void showError(String error) {
    final snackBar = SnackBar(content: Text(error));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    var widget;

    widget = NotificationListener(
        onNotification: _onNotification,
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: this.widget.viewModel.students.length + 1,
            itemBuilder: (_, int index) => _createItem(context, index),
          ),
        ));
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("HomeView"),
		actions: _buildActionButton(),
      ),
	  drawer: _buildDrawer(),
      body: widget,
    );
  }

  bool _onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {

      if (_scrollController.mostRecentlyUpdatedPosition.maxScrollExtent > _scrollController.offset &&
          _scrollController.mostRecentlyUpdatedPosition.maxScrollExtent - _scrollController.offset <= 50) {
        // load more
        if (this.widget.viewModel.getStudentsReport?.status == ActionStatus.complete ||
            this.widget.viewModel.getStudentsReport?.status == ActionStatus.error) {
          // have next page
          _loadMoreData();
          setState(() {});
        } else {}
      }
    }

    return true;
  }

  Future<Null> _loadMoreData() {
    widget.viewModel.getStudents(false);
    return null;
  }

  Future<Null> _handleRefresh() async {
    _refreshIndicatorKey.currentState.show();
    widget.viewModel.getStudents(true);
    return null;
  }

  _createItem(BuildContext context, int index) {
    if (index < this.widget.viewModel.students?.length) {
      return SwipeListItem<Student>(
          item: this.widget.viewModel.students[index],
          onArchive: _handleArchive,
          onDelete: _handleDelete,
          child: Container(
              child: _StudentListItem(
                student: this.widget.viewModel.students[index],
                onTap: () {
                  //Navigator.push(
                  //  context,
                  //  MaterialPageRoute(
                  //    builder: (context) =>
                  //        ViewStudent(student: this.widget.viewModel.students[index]),
                  //  ),
                  //);
                },
              ),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)))));
    }

    return Container(
      height: 44.0,
      child: Center(
        child: _getLoadMoreWidget(),
      ),
    );
  }

  void _handleArchive(Student item) {}

  void _handleDelete(Student item) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text("DELETE"),
            content: Text('Do you want to delete this item'),
            actions: <Widget>[
              FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              FlatButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    this.widget.viewModel.deleteStudent(item);
                    Navigator.pop(context);
                  })
            ],
          ),
    );
  }
  
  Widget _getLoadMoreWidget() {
    if (this.widget.viewModel.getStudentsReport?.status == ActionStatus.running) {
      return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: CircularProgressIndicator());
    } else {
      return SizedBox();
    }
  }

 
  Drawer _buildDrawer() {
    var fontFamily = "Roboto";
    var accountEmail = Text(
        "hay@gmail.com",
        style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontFamily: fontFamily
        )
    );
    var accountName = Text(
        "HAY",
        style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontFamily: fontFamily
        )
    );
    var accountPicture = CircleAvatar(
        child: Image.asset("assets/icons/ic_launcher.png"),
        backgroundColor: Theme.of(context).accentColor
    );

    var header = UserAccountsDrawerHeader(
      accountEmail: accountEmail,
      accountName: accountName,
      onDetailsPressed: _onTap,
      currentAccountPicture: accountPicture,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor
      ),
    );

    var tileItem1 = ListTile(
        leading: Icon(Icons.add_a_photo),
        title: Text("Add Photo"),
        subtitle: Text("Add a photo to your album"),
        onTap: _onTap
    );
    var tileItem2 = ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text("Exit"),
        onTap: _onTap
    );

    var listView = ListView(children: [header, tileItem1, tileItem2]);

    var drawer = Drawer(child: listView);

    return drawer;
  }

  void _onTap() {
    // Update the state of the app
    // ...
    // Then close the drawer
    Navigator.pop(context);
  }
  List<Widget> _buildActionButton() {
    return <Widget>[
      IconButton(
        icon: Icon(choices[0].icon),
        onPressed: () {
          _select(choices[0]);
        },
      ),
    ];
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {});
  }

}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Add', icon: Icons.add),
];

class _StudentListItem extends ListTile {
  _StudentListItem({Student student, GestureTapCallback onTap})
      : super(
            title: Text("Title"),
            subtitle: Text("Subtitle"),
            leading: CircleAvatar(child: Text("T")),
            onTap: onTap);
}
