import 'package:flutter/material.dart';
import 'package:movies_flutter/model/cast.dart';
import 'package:movies_flutter/model/mediaitem.dart';
import 'package:movies_flutter/model/tvseason.dart';
import 'package:movies_flutter/util/mediaproviders.dart';
import 'package:movies_flutter/widgets/actor_detail/actor_detail.dart';
import 'package:movies_flutter/widgets/favorites/favorite_screen.dart';
import 'package:movies_flutter/widgets/media_detail/media_detail.dart';
import 'package:movies_flutter/widgets/search/search_page.dart';
import 'package:movies_flutter/widgets/season_detail/season_detail_screen.dart';

void goToMovieDetails(BuildContext context, MediaItem movie) {
  final MediaProvider provider =
      (movie.type == MediaType.movie) ? MovieProvider() : ShowProvider();
  _pushWidgetWithFade(context, MediaDetailScreen(movie, provider));
}

void goToSeasonDetails(BuildContext context, MediaItem show, TvSeason season) =>
    _pushWidgetWithFade(context, SeasonDetailScreen(show, season));

void goToActorDetails(BuildContext context, Actor actor) {
  _pushWidgetWithFade(context, ActorDetailScreen(actor));
}

void goToSearch(BuildContext context) {
  _pushWidgetWithFade(context, SearchScreen());
}

void goToFavorites(BuildContext context) {
  _pushWidgetWithFade(context, FavoriteScreen());
}

void _pushWidgetWithFade(BuildContext context, Widget widget) {
  Navigator.of(context).push<Widget>(
        PageRouteBuilder(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
            pageBuilder: (BuildContext context, Animation animation,
                Animation secondaryAnimation) {
              return widget;
            }),
      );
}
