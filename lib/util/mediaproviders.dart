import 'dart:async';

import 'package:movies_flutter/model/cast.dart';
import 'package:movies_flutter/model/mediaitem.dart';
import 'package:movies_flutter/util/api_client.dart';

abstract class MediaProvider {
  Future<List<MediaItem>> loadMedia(String category, {int page= 1});

  Future<List<Actor>> loadCast(int mediaId);

  Future<dynamic> getDetails(int mediaId);

  Future<List<MediaItem>> getSimilar(int mediaId);
}

class MovieProvider extends MediaProvider {
  MovieProvider();

  final ApiClient _apiClient = ApiClient();

  @override
  Future<List<MediaItem>> loadMedia(String category, {int page= 1}) {
    return _apiClient.fetchMovies(category: category, page: page);
  }

  @override
  Future<List<MediaItem>> getSimilar(int mediaId) {
    return _apiClient.getSimilarMedia(mediaId, type: "movie");
  }

  @override
  Future<dynamic> getDetails(int mediaId) {
    return _apiClient.getMediaDetails(mediaId, type: "movie");
  }

  @override
  Future<List<Actor>> loadCast(int mediaId) {
    return _apiClient.getMediaCredits(mediaId, type: "movie");
  }
}

class ShowProvider extends MediaProvider {
  ShowProvider();

  final ApiClient _apiClient = ApiClient();

  @override
  Future<List<MediaItem>> loadMedia(String category, {int page= 1}) {
    return _apiClient.fetchShows(category: category, page: page);
  }

  @override
  Future<List<MediaItem>> getSimilar(int mediaId) {
    return _apiClient.getSimilarMedia(mediaId, type: "tv");
  }

  @override
  Future<dynamic> getDetails(int mediaId) {
    return _apiClient.getMediaDetails(mediaId, type: "tv");
  }

  @override
  Future<List<Actor>> loadCast(int mediaId) {
    return _apiClient.getMediaCredits(mediaId, type: "tv");
  }
}
