import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';

import 'package:freemusicdownloader/Controller/AudioPlayerController.dart';
import 'package:freemusicdownloader/Controller/DownloadController.dart';
import 'package:freemusicdownloader/Models/SingleSong.dart';
import 'package:freemusicdownloader/Page/DownloadDialog/DownloadDialog.dart';
import 'package:freemusicdownloader/Shared/ImageQuality.dart';
import 'package:freemusicdownloader/Shared/PopButton.dart';
import 'package:freemusicdownloader/Shared/shimmerlist.dart';

import '../../Shared/ColorList.dart';

class Detail extends StatelessWidget {
  static const pagename = 'Detail';

  final List<Song> songs;
  final String releaseYear;
  final String primaryAtrist;
  final bool isLoading;
  final String routeTitle;
  final String routeId;
  final String routeImage;
  Detail({
    Key? key,
    required this.songs,
    required this.releaseYear,
    required this.primaryAtrist,
    required this.isLoading,
    required this.routeTitle,
    required this.routeId,
    required this.routeImage,
  }) : super(key: key);

  final _audioplayerController = Get.find<AudioPlayerController>();
  final _downloadController = Get.find<DownloadController>();

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    Random _random = Random();
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        _header(context, _random, _size),
        _playAllButton(),
        isLoading
            ? SliverToBoxAdapter(
                child: ShimmerLoading(),
              )
            : _listView(_random, _size),
      ],
    );
  }

  SliverPersistentHeader _header(
      BuildContext context, Random _random, Size _size) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: FlexibleHeaderDelegate(
        leading: popButtom(context,
            ColorList.primaries[_random.nextInt(ColorList.primaries.length)]),
        statusBarHeight: MediaQuery.of(context).padding.top,
        expandedHeight: 250,
        background: MutableBackground(
          collapsedColor: ColorList
              .lightcolors[_random.nextInt(ColorList.lightcolors.length)],
          expandedWidget: Container(
              padding: EdgeInsets.only(
                bottom: 2,
              ),
              foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.9],
                  colors: [
                    Colors.transparent,
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
              child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl:
                      ImageQuality.imageQuality(value: routeImage, size: 350))),
        ),
        children: [
          FlexibleHeaderItem(
            padding: EdgeInsets.only(left: 4),
            options: [HeaderItemOptions.hide],
            expandedAlignment: Alignment.bottomLeft,
            collapsedAlignment: Alignment.center,
            child: Hero(
              tag: routeId,
              child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  height: 150,
                  width: 150,
                  child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: ImageQuality.imageQuality(
                          value: routeImage, size: 350))),
            ),
          ),
          FlexibleHeaderItem(
            expandedAlignment: Alignment.bottomLeft,
            collapsedPadding:
                EdgeInsets.only(left: 50, right: 4, top: 14, bottom: 15),
            expandedPadding: EdgeInsets.only(left: 160, bottom: 50, right: 4),
            child: DelayedDisplay(
              child: Text(
                routeTitle,
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
          primaryAtrist == ''
              ? SizedBox.shrink()
              : FlexibleHeaderItem(
                  expandedAlignment: Alignment.bottomLeft,
                  expandedPadding:
                      EdgeInsets.only(left: 160, bottom: 2, right: 0),
                  options: [HeaderItemOptions.scale],
                  child: SizedBox(
                    height: 50,
                    child: isLoading
                        ? _headerShimmer(_size)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                primaryAtrist,
                                maxLines: 1,
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF333b66).withOpacity(.5),
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                releaseYear,
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

  Shimmer _headerShimmer(Size _size) {
    return Shimmer.fromColors(
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
            width: _size.width - 180,
          ),
          Container(
            margin: EdgeInsets.only(right: 20),
            color: Colors.white,
            height: 20,
            width: 50,
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _playAllButton() {
    return SliverToBoxAdapter(
      child: DelayedDisplay(
        slidingCurve: Curves.bounceOut,
        slidingBeginOffset: const Offset(.5, 0.0),
        child: Container(
          padding: EdgeInsets.only(left: 4, right: 4),
          height: 100,
          child: Row(
            children: [
              Text(
                'Songs',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF333b66),
                  fontSize: 22,
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
              Bounce(
                duration: Duration(milliseconds: 200),
                onPressed: () {
                  _audioplayerController.loadSong(songs, 0, routeId);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FaIcon(
                    _audioplayerController.currentAlbumId == routeId
                        ? FontAwesomeIcons.pause
                        : FontAwesomeIcons.play,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverPadding _listView(Random _random, Size _size) {
    return SliverPadding(
      padding: EdgeInsets.only(bottom: 70),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) => Bounce(
            onPressed: () async {
              _audioplayerController.loadSong(songs, index, routeId);
            },
            duration: Duration(milliseconds: 100),
            child: Card(
              elevation: 0.0,
              clipBehavior: Clip.hardEdge,
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: [0, 1.0],
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
                      ColorList.lightcolors[
                          _random.nextInt(ColorList.lightcolors.length)]
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
                        child: Image.network(
                          ImageQuality.imageQuality(
                            value: songs[index].image,
                            size: 150,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      left: 62,
                      right: 40,
                      child: Text(
                        songs[index].song,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF333b66),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 62,
                      right: 40,
                      child: Text(
                        songs[index].singers,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Bounce(
                        duration: Duration(milliseconds: 100),
                        onPressed: () => _downloadButton(context, index),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          height: 50,
                          width: 40,
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 10, top: 5, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.5),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                            height: 40,
                            width: 40,
                            child: SvgPicture.asset(
                              'assets/download.svg',
                              color: Color(0xFF333b66),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          childCount: songs.length,
        ),
      ),
    );
  }

  void _downloadButton(BuildContext context, int index) {
    _downloadController.songSize(
      songs[index].encryptedMediaUrl,
      songs[index].the320Kbps,
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DownloadDialog(
          songUrl: songs[index].encryptedMediaUrl,
          songName: songs[index].song,
        );
      },
    );
  }
}
