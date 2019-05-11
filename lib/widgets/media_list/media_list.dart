import 'package:flutter/material.dart';
import 'package:movies_flutter/model/mediaitem.dart';
import 'package:movies_flutter/util/mediaproviders.dart';
import 'package:movies_flutter/util/utils.dart';
import 'package:movies_flutter/widgets/media_list/media_list_item.dart';

class MediaList extends StatefulWidget {
  MediaList(this.provider, this.category, {Key key}) : super(key: key);

  final MediaProvider provider;
  final String category;

  @override
  _MediaListState createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  final List<MediaItem> _movies = List<MediaItem>();
  int _pageNumber = 1;
  LoadingState _loadingState = LoadingState.LOADING;
  bool _isLoading = false;

  Future<void> _loadNextPage() async {
    _isLoading = true;
    try {
      final nextMovies =
          await widget.provider.loadMedia(widget.category, page: _pageNumber);
      setState(() {
        _loadingState = LoadingState.DONE;
        _movies.addAll(nextMovies);
        _isLoading = false;
        _pageNumber++;
      });
    } catch (e) {
      _isLoading = false;
      if (_loadingState == LoadingState.LOADING) {
        setState(() => _loadingState = LoadingState.ERROR);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: _getContentSection());
  }

  Widget _getContentSection() {
    switch (_loadingState) {
      case LoadingState.DONE:
        return ListView.builder(
            itemCount: _movies.length,
            itemBuilder: (BuildContext context, int index) {
              if (!_isLoading && index > (_movies.length * 0.7)) {
                _loadNextPage();
              }

              return MediaListItem(_movies[index]);
            });
      case LoadingState.ERROR:
        return const Text('Sorry, there was an error loading the data!');
      case LoadingState.LOADING:
        return const CircularProgressIndicator();
      default:
        return Container();
    }
  }
}
