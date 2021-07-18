import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:freemusicdownloader/Controller/ApiController.dart';
import 'package:freemusicdownloader/Controller/AudioPlayerController.dart';
import 'package:freemusicdownloader/Controller/TogglePlayerSheetController.dart';
import 'package:freemusicdownloader/Shared/ImageQuality.dart';
import 'package:freemusicdownloader/Shared/shimmerlist.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';
import '../../Shared/GradientColorList.dart';

class PlayList extends StatelessWidget {
  static const pagename = 'playList';
  PlayList({Key? key}) : super(key: key);

  final ApiController _apicontroller = Get.find<ApiController>();
  final AudioplayerController _audioplayerController =
      Get.find<AudioplayerController>();
  final TogglePlayersheetController _toggleplayersheet =
      Get.find<TogglePlayersheetController>();
  final int _tilesImageQuality = 50;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _routedata = ModalRoute.of(context)!.settings.arguments as Map;
    Random _random = Random();
    return WillPopScope(
      onWillPop: () async {
        return _toggleplayersheet.isBottomsheetopen.value ? false : true;
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _header(context, _random, _routedata, _width),
            // _playAllButton(),
            Obx(() => _apicontroller.isPlaylistLoading.value
                ? SliverToBoxAdapter(child: ShimmerLoading())
                : _listView(_random, _routedata)),
          ],
        ),
      ),
    );
  }

  SliverPadding _listView(Random _random, Map<dynamic, dynamic> _routedata) {
    return SliverPadding(
      padding: EdgeInsets.only(bottom: 70),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) => Bounce(
            onPressed: () => _audioplayerController.loadPlaylist(index),
            duration: Duration(milliseconds: 100),
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 1,
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: [0, 1.0],
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
                      ColorList.colorList[
                          _random.nextInt(ColorList.colorList.length)]
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.only(right: .1, top: .1),
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            stops: [0.5, .95],
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Theme.of(context).scaffoldBackgroundColor
                            ],
                          ),
                        ),
                        height: 50,
                        width: 50,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: ImageQuality.imageQuality(
                              value:
                                  '${_apicontroller.playListList.value.songs[index].image}',
                              size: _tilesImageQuality),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      left: 52,
                      right: 40,
                      child: Text(
                        '${_apicontroller.playListList.value.songs[index].song}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF333b66),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 52,
                      right: 40,
                      child: Text(
                        _apicontroller
                                    .playListList.value.songs[index].singers ==
                                ''
                            ? '${_apicontroller.playListList.value.songs[index].primaryartists} - ${_apicontroller.playListList.value.songs[index].album}'
                            : '${_apicontroller.playListList.value.songs[index].singers} - ${_apicontroller.playListList.value.songs[index].album}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 0,
                      child: Bounce(
                        duration: Duration(milliseconds: 100),
                        onPressed: () {},
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.5),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          height: 40,
                          width: 40,
                          child: Icon(
                            Icons.file_download,
                            color: Color(0xFF333b66),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          childCount: _apicontroller.playListList.value.songs.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter _playAllButton() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 0),
        height: 70,
        child: Row(
          children: [
            TweenAnimationBuilder(
              duration: Duration(milliseconds: 500),
              tween: Tween<double>(begin: 2, end: 1.0),
              builder: (context, double _value, child) => Transform.scale(
                scale: _value,
                child: Text(
                  'Songs',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF333b66),
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Divider(
                indent: 10,
                thickness: 5,
                height: 10,
                color: Colors.grey.shade200,
              ),
            ),
            TweenAnimationBuilder(
              duration: Duration(milliseconds: 500),
              tween: Tween<double>(begin: 2, end: 1.0),
              builder: (context, double _value, child) => Transform.scale(
                scale: _value,
                child: Icon(
                  Icons.play_arrow,
                  size: 60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverPersistentHeader _header(BuildContext context, Random _random,
      Map<dynamic, dynamic> _routedata, double _width) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: FlexibleHeaderDelegate(
        statusBarHeight: MediaQuery.of(context).padding.top,
        expandedHeight: 250,
        background: MutableBackground(
          collapsedColor:
              ColorList.colorList[_random.nextInt(ColorList.colorList.length)],
          expandedWidget: Container(
            padding: EdgeInsets.only(
              bottom: 30,
            ),
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, .8],
                colors: [
                  Colors.transparent,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
              ),
            ),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: _routedata['image'],
            ),
          ),
        ),
        children: [
          FlexibleHeaderItem(
            padding: EdgeInsets.only(left: 4),
            options: [HeaderItemOptions.hide],
            expandedAlignment: Alignment.bottomLeft,
            collapsedAlignment: Alignment.center,
            child: Hero(
              tag: _routedata['id'],
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                height: 150,
                width: 150,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: _routedata['image'],
                ),
              ),
            ),
          ),
          FlexibleHeaderItem(
            expandedAlignment: Alignment.bottomLeft,
            collapsedPadding:
                EdgeInsets.only(left: 50, right: 4, top: 14, bottom: 15),
            expandedPadding: EdgeInsets.only(left: 170, bottom: 50, right: 4),
            child: DelayedDisplay(
              child: Text(
                '${_routedata['title']}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  height: 1.1,
                  wordSpacing: -1.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF333b66),
                  fontSize: 22,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
