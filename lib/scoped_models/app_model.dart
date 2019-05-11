import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movies_flutter/model/mediaitem.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel extends Model {

  AppModel(this._sharedPrefs) {
    _currentTheme = _sharedPrefs.getInt(_THEME_KEY) ?? 0;
    _favorites.addAll(_sharedPrefs
        .getStringList(_FAVORITES_KEY)
        ?.map((dynamic value) => MediaItem.fromPrefsJson(json.decode(value))) ??
        Set());
  }

  final SharedPreferences _sharedPrefs;
  final Set<MediaItem> _favorites = Set();
  static const _THEME_KEY = "theme_prefs_key";
  static const _FAVORITES_KEY = "media_favorites_key";


  static final List<ThemeData> _themes = [ThemeData.dark(), ThemeData.light()];
  int _currentTheme = 0;

  ThemeData get theme => _themes[_currentTheme];

  List<MediaItem> get favoriteMovies => _favorites
      .where((MediaItem item) => item.type == MediaType.movie)
      .toList();

  List<MediaItem> get favoriteShows => _favorites
      .where((MediaItem item) => item.type == MediaType.show)
      .toList();

  void toggleTheme() {
    _currentTheme = (_currentTheme + 1) % _themes.length;
    _sharedPrefs.setInt(_THEME_KEY, _currentTheme);
    notifyListeners();
  }

  bool isItemFavorite(MediaItem item) =>
      _favorites?.where((MediaItem media) => media.id == item.id)?.length ==
          1 ??
      false;

  // TODO(username): this should ideally be stored in a database and accessed through a repository
  void toggleFavorites(MediaItem favoriteItem) {
    !isItemFavorite(favoriteItem)
        ? _favorites.add(favoriteItem)
        : _favorites
            .removeWhere((MediaItem item) => item.id == favoriteItem.id);

    notifyListeners();

    _sharedPrefs.setStringList(
        _FAVORITES_KEY,
        _favorites
            .toList()
            .map((MediaItem favoriteItem) => json.encode(favoriteItem.toJson()))
            .toList());
  }
}
