import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:freemusicdownloader/GetxBinding/InitialBindidng.dart';
import 'package:freemusicdownloader/Page/Home/Home.dart';
import 'package:freemusicdownloader/Page/PlayerSheet/playersheet.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          MaterialApp(
            debugShowCheckedModeBanner: false,
            color: Colors.pink,
            home: AudioServiceWidget(child: Home()),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AudioServiceWidget(child: PlayerSheet()),
          )
        ],
      ),
    );
  }
}
