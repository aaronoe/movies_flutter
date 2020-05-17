import 'package:flutter/material.dart';
import 'package:movies_flutter/model/mediaitem.dart';
import 'package:movies_flutter/scoped_models/app_model_db.dart';
import 'package:movies_flutter/widgets/media_list/media_list_item.dart';
import 'package:movies_flutter/widgets/utilviews/toggle_theme_widget.dart';
import 'package:scoped_model/scoped_model.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Favorites"),
          actions: <Widget>[ToggleThemeButton()],
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.movie),
              ),
              Tab(
                icon: Icon(Icons.tv),
              ),
            ],
          ),
        ),
        body: ScopedModelDescendant<AppModel>(
          builder: (context, child, AppModel model) => TabBarView(
                children: <Widget>[
                  _FavoriteList(model.favoriteMovies),
                  _FavoriteList(model.favoriteShows),
                ],
              ),
        ),
      ),
    );
  }
}

class _FavoriteList extends StatelessWidget {
  final List<MediaItem> _media;

  const _FavoriteList(this._media, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _media.length == 0
        ? Center(child: Text("You have no favorites yet!"))
        : ListView.builder(
            itemCount: _media.length,
            itemBuilder: (BuildContext context, int index) {
              return MediaListItem(_media[index]);
            });
  }
}
