import 'dart:math';
import 'dart:ui';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freemusicdownloader/Page/DownloadDialog/DownloadSong.dart';
import 'package:freemusicdownloader/Shared/ImagePlaceHolder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';
import 'package:freemusicdownloader/Controller/AudioPlayerController.dart';
import 'package:freemusicdownloader/Models/SingleSong.dart';
import 'package:freemusicdownloader/Shared/ImageQuality.dart';
import 'package:freemusicdownloader/Shared/PopButton.dart';
import 'package:freemusicdownloader/Shared/shimmerlist.dart';

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
        collapsedElevation: 0.0,
        leading: popButtom(context),
        statusBarHeight: MediaQuery.of(context).padding.top,
        expandedHeight: 250,
        background: MutableBackground(
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
              imageUrl: ImageQuality.imageQuality(
                value: routeImage,
                size: 350,
              ),
              placeholder: (context, url) => imagePlaceHolder(),
              errorWidget: (context, url, error) => imagePlaceHolder(),
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
                    value: routeImage,
                    size: 350,
                  ),
                  placeholder: (context, url) => imagePlaceHolder(),
                  errorWidget: (context, url, error) => imagePlaceHolder(),
                ),
              ),
            ),
          ),
          FlexibleHeaderItem(
            expandedAlignment: Alignment.bottomLeft,
            collapsedPadding:
                EdgeInsets.only(left: 50, right: 4, top: 14, bottom: 15),
            expandedPadding: EdgeInsets.only(left: 160, bottom: 50, right: 4),
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
          primaryAtrist == ''
              ? SizedBox.shrink()
              : FlexibleHeaderItem(
                  expandedAlignment: Alignment.bottomLeft,
                  expandedPadding:
                      EdgeInsets.only(left: 160, bottom: 2, right: 0),
                  options: [HeaderItemOptions.scale],
                  child: SizedBox(
                    height: 50,
                    child: Column(
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

  SliverToBoxAdapter _playAllButton() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 60,
        child: Center(
          child: BouncingWidget(
            onPressed: () {
              _audioplayerController.loadSong(songs, 0, '');
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFC2201),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                'Play All Songs',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
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
          (BuildContext context, int index) => ListTile(
            onTap: () {
              _audioplayerController.loadSong(songs, index, routeId);
            },
            horizontalTitleGap: 6.0,
            dense: true,
            leading: Container(
              width: 50,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
              ),
              child: CachedNetworkImage(
                imageUrl: ImageQuality.imageQuality(
                  value: songs[index].image,
                  size: 150,
                ),
                errorWidget: (context, url, error) => imagePlaceHolder(),
                placeholder: (context, url) => imagePlaceHolder(),
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              songs[index].song,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              songs[index].singers,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Bounce(
              duration: Duration(milliseconds: 100),
              onPressed: () {
                Get.bottomSheet(DownloadSong(
                  songName: songs[index].song,
                  songUrl: songs[index].encryptedMediaUrl,
                  is320: songs[index].the320Kbps,
                ));
              },
              child: SvgPicture.asset(
                'assets/download.svg',
                color: Colors.grey.shade600,
                height: 23,
                width: 23,
              ),
            ),
          ),
          childCount: songs.length,
        ),
      ),
    );
  }
}
