import 'package:flutter/material.dart';
import 'package:movies_flutter/model/searchresult.dart';
import 'package:movies_flutter/util/navigator.dart';
import 'package:movies_flutter/util/styles.dart';

class SearchItemCard extends StatelessWidget {

  SearchItemCard(this.item);

  final SearchResult item;


  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Row(
          children: <Widget>[
            FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                width: 100.0,
                height: 150.0,
                placeholder: "assets/placeholder.jpg",
                image: item.imageUrl),
            Container(
              width: 8.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: primaryDark,
                        borderRadius: const BorderRadius.all(Radius.circular(4.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(item.mediaType.toUpperCase(),
                          style: TextStyle(color: colorAccent)),
                    ),
                  ),
                  Container(
                    height: 4.0,
                  ),
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Container(
                    height: 4.0,
                  ),
                  Text(item.subtitle, style: captionStyle)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

   void _handleTap(BuildContext context) {
    switch (item.mediaType) {
      case "movie":
        goToMovieDetails(context, item.asMovie);
        return;
      case "tv":
        goToMovieDetails(context, item.asShow);
        return;
      case "person":
        goToActorDetails(context, item.asActor);
        return;
    }
  }
}
