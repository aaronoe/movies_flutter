import 'package:movies_flutter/util/utils.dart';

class TvSeason {
  String airDate;
  int episodeCount;
  int id;
  String name;
  String overview;
  String posterPath;
  int seasonNumber;

  String getPosterUrl() => getMediumPictureUrl(posterPath);

  String getReleaseYear() {
    return (airDate == null) ? "" : DateTime.parse(airDate).year.toString();
  }

  String getFormattedTitle() {
    if (seasonNumber == 0)
      return 'Extras';
    return 'Season $seasonNumber (${getReleaseYear()})';
  }

  TvSeason.fromMap(Map jsonMap)
      : airDate = jsonMap['air_date'],
        episodeCount = jsonMap['episode_count'],
        id = jsonMap['id'],
        name = jsonMap['name'],
        overview = jsonMap['overview'],
        posterPath = jsonMap['poster_path'] ?? "",
        seasonNumber = jsonMap['season_number'];
}
