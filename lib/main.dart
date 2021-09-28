import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:freemusicdownloader/GetxBinding/InitialBindidng.dart';
import 'package:freemusicdownloader/Page/Home/Home.dart';
import 'package:freemusicdownloader/Page/PlayerSheet/playersheet.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: false // optional: set false to disable printing logs to console
      );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
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
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(accentColor: Colors.transparent)),
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
