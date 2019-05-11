import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

enum LoadingState { DONE, LOADING, WAITING, ERROR }

final dollarFormat = NumberFormat("#,##0.00", "en_US");
final sourceFormat = DateFormat('yyyy-MM-dd');
final dateFormat = DateFormat.yMMMMd("en_US");

Map<int, String> _genreMap = {
  28: 'Action',
  12: 'Adventure',
  16: 'Animation',
  35: 'Comedy',
  80: 'Crime',
  99: 'Documentary',
  18: 'Drama',
  10751: 'Family',
  10762: 'Kids',
  10759: 'Action & Adventure',
  14: 'Fantasy',
  36: 'History',
  27: 'Horror',
  10402: 'Music',
  9648: 'Mystery',
  10749: 'Romance',
  878: 'Science Fiction',
  10770: 'TV Movie',
  53: 'Thriller',
  10752: 'War',
  37: 'Western',
  10763: '',
  10764: 'Reality',
  10765: 'Sci-Fi & Fantasy',
  10766: 'Soap',
  10767: 'Talk',
  10768: 'War & Politics',
};

List<String> getGenresForIds(List<int> genreIds) =>
    genreIds.map((id) => _genreMap[id]).toList();

String getGenreString(List<int> genreIds) {
  final StringBuffer buffer = StringBuffer();
  buffer.writeAll(getGenresForIds(genreIds), ", ");
  return buffer.toString();
}

String concatListToString(List<dynamic> data, String mapKey) {
  final StringBuffer buffer = StringBuffer();
  buffer.writeAll(data.map<String>((dynamic map) => map[mapKey]).toList(), ", ");
  return buffer.toString();
}

String formatSeasonsAndEpisodes(int numberOfSeasons, int numberOfEpisodes) =>
    '$numberOfSeasons Seasons and $numberOfEpisodes Episodes';

String formatNumberToDollars(int amount) => '\$${dollarFormat.format(amount)}';

String formatDate(String date) {
  try {
    return dateFormat.format(sourceFormat.parse(date));
  } catch (Exception) {
    return "";
  }
}

String formatRuntime(int runtime) {
  final int hours = runtime ~/ 60;
  final int minutes = runtime % 60;

  return '$hours\h $minutes\m';
}

Future<void> launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}

String getImdbUrl(String imdbId) => 'http://www.imdb.com/title/$imdbId';

const String _imageUrlLarge = "https://image.tmdb.org/t/p/w500/";
const String _imageUrlMedium = "https://image.tmdb.org/t/p/w300/";

String getMediumPictureUrl(String path) => _imageUrlMedium + path;

String getLargePictureUrl(String path) => _imageUrlLarge + path;
