import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:freemusicdownloader/GetxBinding/InitialBindidng.dart';
import 'package:freemusicdownloader/Page/Home/Home.dart';
import 'package:freemusicdownloader/Page/PlayerSheet/playersheet.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

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
            home: Home(),
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: PlayerSheet())
        ],
      ),
    );
  }
}
