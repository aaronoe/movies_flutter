import 'package:movies_flutter/util/utils.dart';

class MediaItem {

  MediaItem._internalFromJson(Map jsonMap, {MediaType type= MediaType.movie})
      : type = type,
        id = jsonMap["id"].toInt(),
        voteAverage = jsonMap["vote_average"].toDouble(),
        title = jsonMap[(type == MediaType.movie ? "title" : "name")],
        posterPath = jsonMap["poster_path"] ?? "",
        backdropPath = jsonMap["backdrop_path"] ?? "",
        overview = jsonMap["overview"],
        releaseDate = jsonMap[
        (type == MediaType.movie ? "release_date" : "first_air_date")],
        genreIds = (jsonMap["genre_ids"] as List<dynamic>)
            .map<int>((dynamic value) => value.toInt())
            .toList();

  MediaType type;
  int id;
  double voteAverage;
  String title;
  String posterPath;
  String backdropPath;
  String overview;
  String releaseDate;
  List<int> genreIds;



  String getBackDropUrl() => getLargePictureUrl(backdropPath);

  String getPosterUrl() => getMediumPictureUrl(posterPath);

  int getReleaseYear() {
    return releaseDate == null || releaseDate == ""
        ? 0
        : DateTime.parse(releaseDate).year;
  }

  factory MediaItem(Map jsonMap, MediaType type) =>
      MediaItem._internalFromJson(jsonMap, type: type);


  Map toJson() => <String, dynamic>{
        'type': type == MediaType.movie ? 1 : 0,
        'id': id,
        'vote_average': voteAverage,
        'title': title,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'overview': overview,
        'release_date': releaseDate,
        'genre_ids': genreIds
      };

  factory MediaItem.fromPrefsJson(Map jsonMap) => MediaItem._internalFromJson(
      jsonMap,
      type: (jsonMap['type'].toInt() == 1) ? MediaType.movie : MediaType.show);
}

enum MediaType { movie, show }
