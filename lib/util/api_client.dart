import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:movies_flutter/model/cast.dart';
import 'package:movies_flutter/model/episode.dart';
import 'package:movies_flutter/model/mediaitem.dart';
import 'package:movies_flutter/model/searchresult.dart';
import 'package:movies_flutter/model/tvseason.dart';
import 'package:movies_flutter/util/constants.dart';

class ApiClient {

  factory ApiClient() => _client;

  ApiClient._internal();

  static final _client = ApiClient._internal();
  final HttpClient _http = HttpClient();

  final String baseUrl = 'api.themoviedb.org';


  Future<dynamic> _getJson(Uri uri) async {
    final response = await (await _http.getUrl(uri)).close();
    final transformedResponse = await response.transform(utf8.decoder).join();
    return json.decode(transformedResponse);
  }

  Future<List<MediaItem>> fetchMovies(
      {int page= 1, String category= "popular"}) async {
    final url = Uri.https(baseUrl, '3/movie/$category',
        {'api_key': API_KEY, 'page': page.toString()});

    return _getJson(url).then<dynamic>((dynamic json) => json['results']).then((dynamic data) => data
        .map<MediaItem>((dynamic item) => MediaItem(item, MediaType.movie))
        .toList());
  }

  Future<List<MediaItem>> getSimilarMedia(int mediaId,
      {String type= "movie"}) async {
    final url = Uri.https(baseUrl, '3/$type/$mediaId/similar', {
      'api_key': API_KEY,
    });

    return _getJson(url).then<dynamic>((dynamic json) => json['results']).then((dynamic data) => data
        .map<MediaItem>((dynamic item) => MediaItem(
            item, (type == "movie") ? MediaType.movie : MediaType.show))
        .toList());
  }

  Future<List<MediaItem>> getMoviesForActor(int actorId) async {
    final url = Uri.https(baseUrl, '3/discover/movie', {
      'api_key': API_KEY,
      'with_cast': actorId.toString(),
      'sort_by': 'popularity.desc'
    });

    return _getJson(url).then<dynamic>((dynamic json) => json['results']).then((dynamic data) => data
        .map<MediaItem>((dynamic item) => MediaItem(item, MediaType.movie))
        .toList());
  }

  Future<List<MediaItem>> getShowsForActor(int actorId) async {
    final url = Uri.https(baseUrl, '3/person/$actorId/tv_credits', {
      'api_key': API_KEY,
    });

    return _getJson(url).then<dynamic>((dynamic json) => json['cast']).then((dynamic data) => data
        .map<MediaItem>((dynamic item) => MediaItem(item, MediaType.show))
        .toList());
  }

  Future<List<Actor>> getMediaCredits(int mediaId,
      {String type= "movie"}) async {
    final url =
        Uri.https(baseUrl, '3/$type/$mediaId/credits', {'api_key': API_KEY});

    return _getJson(url).then((dynamic json) =>
        json['cast'].map<Actor>((dynamic item) => Actor.fromJson(item)).toList());
  }

  Future<dynamic> getMediaDetails(int mediaId, {String type= "movie"}) async {
    final url = Uri.https(baseUrl, '3/$type/$mediaId', {'api_key': API_KEY});

    return _getJson(url);
  }

  Future<List<TvSeason>> getShowSeasons(int showId) async {
    final dynamic detailJson = await getMediaDetails(showId, type: 'tv');
    return detailJson['seasons']
        .map<TvSeason>((dynamic item) => TvSeason.fromMap(item))
        .toList();
  }

  Future<List<SearchResult>> getSearchResults(String query) {
    final url = Uri
        .https(baseUrl, '3/search/multi', {'api_key': API_KEY, 'query': query});

    return _getJson(url).then((dynamic json) => json['results']
        .map<SearchResult>((dynamic item) => SearchResult.fromJson(item))
        .toList());
  }

  Future<List<MediaItem>> fetchShows(
      {int page= 1, String category= "popular"}) async {
    final url = Uri.https(baseUrl, '3/tv/$category',
        {'api_key': API_KEY, 'page': page.toString()});

    return _getJson(url).then<dynamic>((dynamic json) => json['results']).then((dynamic data) => data
        .map<MediaItem>((dynamic item) => MediaItem(item, MediaType.show))
        .toList());
  }

  Future<List<Episode>> fetchEpisodes(int showId, int seasonNumber) {
    final url = Uri.https(baseUrl, '3/tv/$showId/season/$seasonNumber', {
      'api_key': API_KEY,
    });

    return _getJson(url).then<dynamic>((dynamic json) => json['episodes']).then(
        (dynamic data) => data.map<Episode>((dynamic item) => Episode.fromJson(item)).toList());
  }
}
