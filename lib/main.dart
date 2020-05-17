import 'package:flutter/material.dart';
import 'package:movies_flutter/app.dart';
import 'package:movies_flutter/scoped_models/app_model_db.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  runApp(ScopedModel<AppModel>(
      model: AppModel(sharedPreferences), child: CinematicApp()));
}
