import 'package:flutter/material.dart';

class BottomGradient extends StatelessWidget {

  BottomGradient({this.offset= 0.95});

  BottomGradient.noOffset() : offset = 1.0;

  final double offset;


  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        end: const FractionalOffset(0.0, 0.0),
        begin: FractionalOffset(0.0, offset),
        colors: <Color>[
          const Color(0xff222128),
          const Color(0x442C2B33),
          const Color(0x002C2B33)
        ],
      )),
    );
  }
}
