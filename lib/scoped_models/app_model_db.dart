import 'package:flutter/material.dart';
import 'package:movies_flutter/model/mediaitem.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:convert';

//APP model with DB SQlLite
class AppModel extends Model {
  final SharedPreferences _sharedPrefs;
  Set<MediaItem> _favorites = Set();

  static const _THEME_KEY = "theme_prefs_key";
  static const _FAVORITES_KEY = "media_favorites_key";
  
  static  Future  database() async{ return  openDatabase(
    join(await getDatabasesPath(), 'favorites.db'),
    // When the database is first created, create a table.
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE favorites(id INTEGER PRIMARY KEY, type TEXT, voteAverage NUMBER, title TEXT, posterPath TEXT,  backdropPath TEXT, overview TEXT, releaseDate TEXT, genreIds TEXT)",
      );
    },
    version: 1,
  );}

AppModel(this._sharedPrefs) {
    _currentTheme = _sharedPrefs.getInt(_THEME_KEY) ?? 0;
    favorites().then((value) =>  {
    _favorites.addAll(value)
    
    } ).whenComplete(()=>{notifyListeners(), print("pera"),
    });
}
Future<void> insertFavorite(MediaItem item) async {
    // Get a reference to the database.
    final Database db = await database();
        print(item);

    await db.insert(
      'favorites',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MediaItem>> favorites() async {
    // Get a reference to the database.
    final Database db = await database();
    // Query the table for all objetcs.
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    // Convert the List<Map<String, dynamic> into a List<MediaItem>.
    return List.generate(maps.length, (i) {
        
      return MediaItem.fromDB(
       type: (int.parse(maps[i]['type'])==1)? MediaType.movie: MediaType.show,
        id: maps[i]['id'],
        voteAverage:(maps[i]['voteAverage']+.0),
        title: maps[i]['title'],
        posterPath: maps[i]['posterPath'],
        backdropPath: maps[i]['backdropPath'],
        overview: maps[i]['overview'],
        releaseDate: maps[i]['releaseDate'],
        genreIds: json.decode(maps[i]['genreIds']).cast<int>()
      );
    });
  }

  Future<void> deleteFavorite(int id) async {
    // Get a reference to the database.
    final db = await database();

    // Remove the MediaItem from the database.
    await db.delete(
      'favorites',
      // Use a `where` clause to delete a specific MediaItem.
      where: "id = ?",
      // Pass the MediaItem's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }


 static List<ThemeData> _themes = [ThemeData.dark(), ThemeData.light()];
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

  void toggleFavorites(MediaItem favoriteItem) {
   
if(!isItemFavorite(favoriteItem)){
_favorites.add(favoriteItem);
insertFavorite(favoriteItem);
}else{
_favorites
            .removeWhere((MediaItem item) => item.id == favoriteItem.id);
            deleteFavorite(favoriteItem.id);
}
    notifyListeners();

 
}
}

