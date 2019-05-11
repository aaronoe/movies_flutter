import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movies_flutter/model/cast.dart';
import 'package:movies_flutter/model/mediaitem.dart';
import 'package:movies_flutter/util/api_client.dart';
import 'package:movies_flutter/util/styles.dart';
import 'package:movies_flutter/widgets/media_list/media_list_item.dart';
import 'package:movies_flutter/widgets/utilviews/fitted_circle_avatar.dart';

class ActorDetailScreen extends StatelessWidget {

  ActorDetailScreen(this._actor);

  final Actor _actor;
  final ApiClient _apiClient = ApiClient();


  @override
  Widget build(BuildContext context) {
    final movieFuture = _apiClient.getMoviesForActor(_actor.id);
    final showFuture = _apiClient.getShowsForActor(_actor.id);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: primary,
        body: NestedScrollView(
          body: TabBarView(
            children: <Widget>[
              _buildMoviesSection(movieFuture),
              _buildMoviesSection(showFuture),
            ],
          ),
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) =>
                  [_buildAppBar(context, _actor)],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Actor actor) {
    return SliverAppBar(
      expandedHeight: 240.0,
      bottom: TabBar(
        tabs: <Widget>[
          const Tab(
            icon: Icon(Icons.movie),
          ),
          const Tab(
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

  Widget _buildMoviesSection(Future<List<MediaItem>> future) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<MediaItem>> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    MediaListItem(snapshot.data[index]),
                itemCount: snapshot.data.length,
              )
            : Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(child: const CircularProgressIndicator()),
              );
      },
    );
  }
}
