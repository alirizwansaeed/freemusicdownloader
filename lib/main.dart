import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:freemusicdownloader/GetxBinding/InitialBindidng.dart';
import 'package:freemusicdownloader/Page/Album/Album.dart';
import 'package:freemusicdownloader/Page/Home/Home.dart';
import 'package:freemusicdownloader/Page/PlayerSheet/playersheet.dart';
import 'package:freemusicdownloader/Page/playlist.dart/Playlist.dart';
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
            routes: {
              Album.pagename: (context) => Album(),
              PlayList.pagename: (context) => PlayList()
            },
            debugShowCheckedModeBanner: false,
            color: Colors.pink,
            home: Home(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: PlayerSheet(),
          )
        ],
      ),
    );
  }
}
