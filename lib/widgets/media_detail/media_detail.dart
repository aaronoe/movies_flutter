import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movies_flutter/model/cast.dart';
import 'package:movies_flutter/model/mediaitem.dart';
import 'package:movies_flutter/model/tvseason.dart';
import 'package:movies_flutter/scoped_models/app_model.dart';
import 'package:movies_flutter/util/api_client.dart';
import 'package:movies_flutter/util/mediaproviders.dart';
import 'package:movies_flutter/util/styles.dart';
import 'package:movies_flutter/util/utils.dart';
import 'package:movies_flutter/widgets/media_detail/cast_section.dart';
import 'package:movies_flutter/widgets/media_detail/meta_section.dart';
import 'package:movies_flutter/widgets/media_detail/season_section.dart';
import 'package:movies_flutter/widgets/media_detail/similar_section.dart';
import 'package:movies_flutter/widgets/utilviews/bottom_gradient.dart';
import 'package:movies_flutter/widgets/utilviews/text_bubble.dart';
import 'package:scoped_model/scoped_model.dart';

class MediaDetailScreen extends StatefulWidget {

  MediaDetailScreen(this._mediaItem, this.provider);

  final MediaItem _mediaItem;
  final MediaProvider provider;
  final ApiClient _apiClient = ApiClient();


  @override
  MediaDetailScreenState createState() {
    return MediaDetailScreenState();
  }
}

class MediaDetailScreenState extends State<MediaDetailScreen> {
  List<Actor> _actorList;
  List<TvSeason> _seasonList;
  List<MediaItem> _similarMedia;
  dynamic _mediaDetails;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _loadCast();
    _loadDetails();
    _loadSimilar();
    if (widget._mediaItem.type == MediaType.show)
      _loadSeasons();

    Timer(Duration(milliseconds: 100), () => setState(() => _visible = true));
  }

  Future<void> _loadCast() async {
    try {
      final List<Actor> cast = await widget.provider.loadCast(widget._mediaItem.id);
      setState(() => _actorList = cast);
    } catch (e) {
      //No debería generar excepcion
    }
  }

  Future<void> _loadDetails() async {
    try {
      final dynamic details = await widget.provider.getDetails(widget._mediaItem.id);
      setState(() => _mediaDetails = details);
    } catch (e) {
      e.toString();
    }
  }

  Future<void> _loadSeasons() async {
    try {
      final List<TvSeason> seasons =
          await widget._apiClient.getShowSeasons(widget._mediaItem.id);
      setState(() => _seasonList = seasons);
    } catch (e) {//No debería generar excepcion
      }
  }

  Future<void> _loadSimilar() async {
    try {
      final List<MediaItem> similar =
          await widget.provider.getSimilar(widget._mediaItem.id);
      setState(() => _similarMedia = similar);
    } catch (e) {//No debería generar excepcion
       }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primary,
        body: CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(widget._mediaItem),
            _buildContentSection(widget._mediaItem),
          ],
        ));
  }

  Widget _buildAppBar(MediaItem movie) {
    return SliverAppBar(
      expandedHeight: 240.0,
      pinned: true,
      actions: <Widget>[
        ScopedModelDescendant<AppModel>(
            builder: (BuildContext context, child, AppModel model) => IconButton(
                icon: Icon(model.isItemFavorite(widget._mediaItem)
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () => model.toggleFavorites(widget._mediaItem)))
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: "Movie-Tag-${widget._mediaItem.id}",
              child: FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: "assets/placeholder.jpg",
                  image: widget._mediaItem.getBackDropUrl()),
            ),
            BottomGradient(),
            _buildMetaSection(movie)
          ],
        ),
      ),
    );
  }

  Widget _buildMetaSection(MediaItem mediaItem) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                TextBubble(
                  mediaItem.getReleaseYear().toString(),
                  backgroundColor: const Color(0xffF47663),
                ),
                Container(
                  width: 8.0,
                ),
                TextBubble(mediaItem.voteAverage.toString(),
                    backgroundColor: const Color(0xffF47663)),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(mediaItem.title,
                  style: const TextStyle(color: Color(0xFFEEEEEE), fontSize: 20.0)),
            ),
            Row(
              children: getGenresForIds(mediaItem.genreIds)
                  .sublist(0, min(5, mediaItem.genreIds.length))
                  .map((String genre) => Row(
                        children: <Widget>[
                          TextBubble(genre),
                          Container(
                            width: 8.0,
                          )
                        ],
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(MediaItem media) {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        Container(
          decoration: BoxDecoration(color: const Color(0xff222128)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "SYNOPSIS",
                  style: const TextStyle(color: Colors.white),
                ),
                Container(
                  height: 8.0,
                ),
                Text(media.overview,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 12.0)),
                Container(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(color: primary),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _actorList == null
                  ? Center(
                      child: const CircularProgressIndicator(),
                    )
                  : CastSection(_actorList)),
        ),
        Container(
          decoration: BoxDecoration(color: primaryDark),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _mediaDetails == null
                  ? Center(
                      child: const CircularProgressIndicator(),
                    )
                  : MetaSection(_mediaDetails)),
        ),
        (widget._mediaItem.type == MediaType.show)
            ? Container(
                decoration: BoxDecoration(color: primary),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _seasonList == null
                        ? Container()
                        : SeasonSection(widget._mediaItem, _seasonList)),
              )
            : Container(),
        Container(
            decoration: BoxDecoration(
                color: widget._mediaItem.type == MediaType.movie
                    ? primary
                    : primaryDark),
            child: _similarMedia == null
                ? Container()
                : SimilarSection(_similarMedia))
      ]),
    );
  }
}
