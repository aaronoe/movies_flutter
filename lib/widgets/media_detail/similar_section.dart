import 'package:flutter/material.dart';
import 'package:movies_flutter/model/mediaitem.dart';
import 'package:movies_flutter/util/navigator.dart';

class SimilarSection extends StatelessWidget {

  SimilarSection(this._similarMovies);

  final List<MediaItem> _similarMovies;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Similar",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Container(
          height: 300.0,
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            scrollDirection: Axis.horizontal,
            children: _similarMovies
                .map((MediaItem movie) => GestureDetector(
                      onTap: () => goToMovieDetails(context, movie),
                      child: FadeInImage.assetNetwork(
                        image: movie.getPosterUrl(),
                        placeholder: 'assets/placeholder.jpg',
                        height: 150.0,
                        fit: BoxFit.cover,
                      ),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
