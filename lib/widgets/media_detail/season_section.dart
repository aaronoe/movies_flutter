import 'package:flutter/material.dart';
import 'package:movies_flutter/model/mediaitem.dart';
import 'package:movies_flutter/model/tvseason.dart';
import 'package:movies_flutter/widgets/media_detail/season-card.dart';

class SeasonSection extends StatelessWidget {

  SeasonSection(this._show, this._seasons);

  final MediaItem _show;
  final List<TvSeason> _seasons;



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "Seasons",
          style: TextStyle(color: Colors.white),
        ),
        Container(
          height: 8.0,
        ),
        Container(
          height: 140.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _seasons
                .map((TvSeason season) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SeasonCard(_show, season),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
