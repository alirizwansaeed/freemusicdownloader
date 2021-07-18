import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:freemusicdownloader/Controller/AudioPlayerController.dart';
import 'package:freemusicdownloader/Models/MainPageModel.dart';
import 'package:freemusicdownloader/Page/Album/Album.dart';
import 'package:freemusicdownloader/Page/playlist.dart/Playlist.dart';
import 'package:freemusicdownloader/Shared/ImageQuality.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:freemusicdownloader/Controller/ApiController.dart';

import '../../Shared/GradientColorList.dart';

class HomeGridView extends StatelessWidget {
  HomeGridView({Key? key, required this.list}) : super(key: key);
  late final ApiController _apiController = Get.find<ApiController>();
  final AudioplayerController _audioplayerController =
      Get.find<AudioplayerController>();
  late final List list;
  final int _gridImageQuality = 150;

  @override
  Widget build(BuildContext context) {
    print('grid rebuild');
    final safeAreaHeight = MediaQuery.of(context).padding.top;
    Random random = Random();

    return StaggeredGridView.countBuilder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(
          top: safeAreaHeight + 200, right: 8, left: 8, bottom: 70),
      crossAxisCount: 2,
      itemCount: list.length,
      staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 8.0,
      itemBuilder: (BuildContext context, int index) => Bounce(
        duration: Duration(milliseconds: 200),
        onPressed: () async {
          if (list[index].type == ContentType.ALBUM) {
            Navigator.of(context).pushNamed(Album.pagename, arguments: {
              "image": list[index].image,
              "title": list[index].title,
              "id": list[index].id
            });
            _apiController.fetchAlbum(list[index].id);
          }
          if (list[index].type == ContentType.PLAYLIST) {
            Navigator.of(context).pushNamed(PlayList.pagename, arguments: {
              "image": list[index].image,
              "title": list[index].title,
              "id": list[index].id
            });
            _apiController.fetchPlaylist(list[index].id);
          }
          if (list[index].type == ContentType.SONG) {
            await _apiController.fetchSong(list[index].id);
            await _audioplayerController.loadsong();
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipPath(
              clipper: GridViewClipper(),
              child: Container(
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    colors: [
                      ColorList.colorList[
                          random.nextInt(ColorList.colorList.length)],
                      ColorList.colorList[
                          random.nextInt(ColorList.colorList.length)],
                    ],
                  ),
                ),
              ),
            ),
            Hero(
              tag: list[index].id,
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.only(right: 25, left: 25, bottom: 50),
                child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: ImageQuality.imageQuality(
                        value: list[index].image, size: _gridImageQuality)),
              ),
            ),
            Positioned(
              bottom: 25,
              left: 5,
              right: 5,
              child: Center(
                child: Text(
                  '${list[index].title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w900, color: Color(0xFF333b66)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridViewClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.5000000);
    path_0.lineTo(0, size.height);
    path_0.lineTo(size.width, size.height);
    path_0.quadraticBezierTo(size.width * 1.0016000, size.height * 0.2538600,
        size.width, size.height * 0.0315000);
    path_0.cubicTo(
        size.width * 1.0010800,
        size.height * 0.0148600,
        size.width * 0.9800600,
        size.height * 0.0030400,
        size.width * 0.9448000,
        size.height * 0.0187200);
    path_0.cubicTo(
        size.width * 0.8799600,
        size.height * 0.0477200,
        size.width * 0.2682400,
        size.height * 0.3309600,
        size.width * 0.0345600,
        size.height * 0.4433400);
    path_0.quadraticBezierTo(size.width * 0.0004200, size.height * 0.4567800, 0,
        size.height * 0.5000000);
    path_0.close();
    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
