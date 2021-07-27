import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DelayedDisplay(
        slidingBeginOffset: Offset(.2, 0.0),
        child: SafeArea(
            child: Container(
          height: 40,
          width: 60,
          padding: EdgeInsets.only(top: 0, bottom: 0),
          decoration: BoxDecoration(
            color: Colors.pink,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
            size: 40,
          ),
        )),
      ),
    );
  }
}
