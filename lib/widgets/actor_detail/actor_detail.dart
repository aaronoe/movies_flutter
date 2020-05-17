import 'dart:async';
import 'package:movies_flutter/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:movies_flutter/model/cast.dart';
import 'package:movies_flutter/model/mediaitem.dart';
import 'package:movies_flutter/util/api_client.dart';
import 'package:movies_flutter/util/styles.dart';
import 'package:movies_flutter/widgets/media_list/media_list_item.dart';
import 'package:movies_flutter/widgets/utilviews/fitted_circle_avatar.dart';

class ActorDetailScreen extends StatelessWidget {
  final Actor _actor;
  final ApiClient _apiClient = ApiClient();

  ActorDetailScreen(this._actor);

  @override
  Widget build(BuildContext context) {
    var movieFuture = _apiClient.getMoviesForActor(_actor.id);
    var showFuture = _apiClient.getShowsForActor(_actor.id);
    var connectivity = isConnected();
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: primary,
        body: FutureBuilder(
      future:  connectivity,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return snapshot.hasData ? NestedScrollView(
          body: TabBarView(
            children: <Widget>[
              _buildMoviesSection(movieFuture, snapshot.data),
              _buildMoviesSection(showFuture, snapshot.data),
            ],
          ),
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) =>
                  [_buildAppBar(context, _actor)],
        ): Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(child: CircularProgressIndicator()));
                }),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Actor actor) {
    return SliverAppBar(
      expandedHeight: 240.0,
      bottom: TabBar(
        tabs: <Widget>[
          Tab(
            icon: Icon(Icons.movie),
          ),
          Tab(
            icon: Icon(Icons.tv),
          ),
        ],
      ),
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            const Color(0xff2b5876),
            const Color(0xff4e4376),
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).padding.top,
              ),
              Hero(
                  tag: 'Cast-Hero-${actor.id}',
                  child: Container(
                    width: 112.0,
                    height: 112.0,
                    child: FittedCircleAvatar(
                      backgroundImage: NetworkImage(actor.profilePictureUrl),
                    ),
                  )),
              Container(
                height: 8.0,
              ),
              Text(
                actor.name,
                style: whiteBody.copyWith(fontSize: 22.0),
              ),
              Container(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoviesSection(Future<List<MediaItem>> future, bool connectivity) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<MediaItem>> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    MediaListItem(snapshot.data[index]),
                itemCount: snapshot.data.length,
              )
            : connectivity ? Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(child: CircularProgressIndicator()),
              ): Center(child: Text("Sorry, you do not have internet access"));
      },
    );
  }
}
