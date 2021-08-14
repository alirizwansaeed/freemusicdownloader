import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget popButtom(BuildContext context, Color color) {
  return GestureDetector(
    onTap: () => Navigator.of(context).pop(),
    child: Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 5),
      width: 30,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Icon(
        Icons.chevron_left,
        color: Colors.white,
        size: 30,
      ),
    ),
  );
}
