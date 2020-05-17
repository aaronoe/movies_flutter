import 'package:flutter/material.dart';
import 'package:movies_flutter/scoped_models/app_model_db.dart';
import 'package:scoped_model/scoped_model.dart';

class ToggleThemeButton extends StatelessWidget {
  const ToggleThemeButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => IconButton(
          icon: Icon(
            Icons.color_lens,
            color: Colors.white,
          ),
          onPressed: () => model.toggleTheme()),
    );
  }
}
