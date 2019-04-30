import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redux_example/data/model/photo_data.dart';
import 'package:redux_example/data/model/choice_data.dart';
import 'package:redux_example/features/settings/settings_option.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redux_example/trans/translations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_example/redux/app/app_state.dart';
import 'package:redux_example/features/home/home_view_model.dart';
import 'package:redux_example/redux/action_report.dart';
import 'package:redux_example/utils/progress_dialog.dart';

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
  final _SearchDemoSearchDelegate _delegate = _SearchDemoSearchDelegate();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final TrackingScrollController _scrollController = TrackingScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    if (this.widget.viewModel.photos.length == 0) {
      this.widget.viewModel.getPhotos(true);
    }
  }
  


  @override
  void didUpdateWidget(HomeViewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(Duration.zero, () {
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
            itemCount: this.widget.viewModel.photos.length + 1,
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
        if (this.widget.viewModel.getPhotosReport?.status == ActionStatus.complete ||
            this.widget.viewModel.getPhotosReport?.status == ActionStatus.error) {
          // have next page
          _loadMoreData();
          setState(() {});
        } else {}
      }
    }

    return true;
  }

  Future<Null> _loadMoreData() {
    widget.viewModel.getPhotos(false);
    return null;
  }

  Future<Null> _handleRefresh() async {
    _refreshIndicatorKey.currentState.show();
    widget.viewModel.getPhotos(true);
    return null;
  }

  _createItem(BuildContext context, int index) {
    if (index < this.widget.viewModel.photos?.length) {
      return Container(
              child: _PhotoListItem(
                photo: this.widget.viewModel.photos[index],
                onTap: () {
                  //Navigator.push(
                  //  context,
                  //  MaterialPageRoute(
                  //    builder: (context) =>
                  //        ViewPhoto(photo: this.widget.viewModel.photos[index]),
                  //  ),
                  //);
                },
              ),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))));
    }

    return Container(
      height: 44.0,
      child: Center(
        child: _getLoadMoreWidget(),
      ),
    );
  }
  
  Widget _getLoadMoreWidget() {
    if (this.widget.viewModel.getPhotosReport?.status == ActionStatus.running) {
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
        onPressed: () async {
          final int selected = await showSearch<int>(
            context: context,
            delegate: _delegate,
          );
          if (selected != null) {
            setState(() {
              showError("you select $selected");
            });
          }
        },
      ),
      IconButton(
        icon: Icon(choices[1].icon),
        onPressed: () async {
            Navigator.of(context).pushNamed("/settings");
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
  const Choice(title: 'Search', icon: Icons.search),
  const Choice(title: 'Settings', icon: Icons.settings),
];

class _PhotoListItem extends ListTile {
  _PhotoListItem({Photo photo, GestureTapCallback onTap})
      : super(
      title: Text(photo.id),
      subtitle: Text(photo.views==null?"0":photo.views.toString()),
      leading: CircleAvatar(child: Image.network(photo.urls.thumb)),
      onTap: onTap);
}

class _SearchDemoSearchDelegate extends SearchDelegate<int> {
  final List<int> _data =
      List<int>.generate(100001, (int i) => i).reversed.toList();
  final List<int> _history = <int>[42607, 85604, 66374, 44, 174];

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<int> suggestions = query.isEmpty
        ? _history
        : _data.where((int i) => '$i'.startsWith(query));

    return _SuggestionList(
      query: query,
      suggestions: suggestions.map((int i) => '$i').toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        showResults(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final int searched = int.tryParse(query);
    if (searched == null || !_data.contains(searched)) {
      return Center(
        child: Text(
          '"$query"\n is not a valid integer between 0 and 100,000.\nTry again.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView(
      children: <Widget>[
        _ResultCard(
          title: 'This integer',
          integer: searched,
          searchDelegate: this,
        ),
        _ResultCard(
          title: 'Next integer',
          integer: searched + 1,
          searchDelegate: this,
        ),
        _ResultCard(
          title: 'Previous integer',
          integer: searched - 1,
          searchDelegate: this,
        ),
      ],
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? IconButton(
              tooltip: 'Voice Search',
              icon: const Icon(Icons.mic),
              onPressed: () {
                query = 'TODO: implement voice input';
              },
            )
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
    ];
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({this.integer, this.title, this.searchDelegate});

  final int integer;
  final String title;
  final SearchDelegate<int> searchDelegate;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        searchDelegate.close(context, integer);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(title),
              Text(
                '$integer',
                style: theme.textTheme.headline.copyWith(fontSize: 72.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style:
                  theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: theme.textTheme.subhead,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
