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
import 'package:freemusicdownloader/Shared/shimmerlist.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';
import '../../Shared/GradientColorList.dart';

class Album extends StatelessWidget {
  static const pagename = 'Album';
  Album({Key? key}) : super(key: key);

  final ApiController _apicontroller = Get.find<ApiController>();
  final AudioplayerController _audioplayerController =
      Get.find<AudioplayerController>();
  final TogglePlayersheetController _toggleplayersheet =
      Get.find<TogglePlayersheetController>();
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
        body: Obx(
          () => CustomScrollView(
            slivers: [
              _header(context, _random, _routedata, _width),
              _playAllButton(),
              _apicontroller.isAlbumLoading.value
                  ? SliverToBoxAdapter(child: ShimmerLoading())
                  : _listView(_random, _routedata),
            ],
          ),
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
            onPressed: () => _audioplayerController.loadalbum(index),
            duration: Duration(milliseconds: 100),
            child: Card(
              clipBehavior: Clip.hardEdge,
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
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            stops: [0.6, 1.0],
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Theme.of(context).scaffoldBackgroundColor
                            ],
                          ),
                        ),
                        height: 60,
                        width: 60,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: _routedata['image'],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      left: 62,
                      right: 40,
                      child: Text(
                        '${_apicontroller.albumList.value.songs[index].song}',
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
                      left: 62,
                      right: 40,
                      child: Text(
                        _apicontroller.albumList.value.songs[index].singers ==
                                ''
                            ? '${_apicontroller.albumList.value.primaryArtists}'
                            : '${_apicontroller.albumList.value.songs[index].singers}',
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
          childCount: _apicontroller.albumList.value.songs.length,
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
            expandedPadding: EdgeInsets.only(left: 170, bottom: 70, right: 4),
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
          ),
          FlexibleHeaderItem(
            expandedAlignment: Alignment.bottomLeft,
            expandedPadding: EdgeInsets.only(left: 170, bottom: 10, right: 0),
            options: [HeaderItemOptions.scale],
            child: SizedBox(
              height: 50,
              child: _apicontroller.isAlbumLoading.value
                  ? Shimmer.fromColors(
                      period: Duration(milliseconds: 500),
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            color: Colors.white,
                            height: 25,
                            width: _width - 180,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            color: Colors.white,
                            height: 20,
                            width: 50,
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_apicontroller.albumList.value.primaryArtists}',
                          maxLines: 1,
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF333b66).withOpacity(.5),
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '${_apicontroller.albumList.value.year}',
                          maxLines: 1,
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
