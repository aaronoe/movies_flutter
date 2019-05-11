import 'package:movies_flutter/util/utils.dart';

class Actor {
  String character;
  String name;
  String profilePicture;
  int id;

  String get profilePictureUrl =>
      getMediumPictureUrl(profilePicture != null ? profilePicture : "");

  Actor.fromJson(Map jsonMap)
      : character = jsonMap['character'],
        name = jsonMap['name'],
        profilePicture = jsonMap['profile_path'],
        id = jsonMap['id'];
}
