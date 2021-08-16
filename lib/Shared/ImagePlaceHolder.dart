import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget imagePlaceHolder() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.black12, Colors.black26],
      ),
    ),
    height: 50,
    child: Center(
      child: FaIcon(
        FontAwesomeIcons.music,
        color: Colors.white,
      ),
    ),
  );
}
