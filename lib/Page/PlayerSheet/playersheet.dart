import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:freemusicdownloader/Controller/AudioController.dart';
import 'package:freemusicdownloader/Controller/TogglePlayerSheetController.dart';
import 'package:freemusicdownloader/Page/PlayerSheet/ProgressSlider.dart';
import 'package:freemusicdownloader/Shared/ColorList.dart';
import 'package:freemusicdownloader/Shared/ImageQuality.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerSheet extends StatefulWidget {
  PlayerSheet({Key? key}) : super(key: key);

  @override
  _PlayerSheetState createState() => _PlayerSheetState();
}

class _PlayerSheetState extends State<PlayerSheet> {
  final _controller = SolidController();
  final _toggleplayersheet = Get.find<TogglePlayersheetController>();
  final _audioController = Get.find<AudioController>();

  Rx<bool> _isopen = false.obs;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaquary = MediaQuery.of(context);
    Random _random = Random();
    Widget _sheetbody() {
      if (_isopen.value) {
        if (_audioController.isLoadingState) {
          return SizedBox.shrink();
        }
        if (_audioController.isNoneState) {
          return Center(child: Text('No song chosen'));
        }
        return _openSheet(_mediaquary);
      } else {
        if (_audioController.isLoadingState) {
          return Shimmer.fromColors(
            period: Duration(milliseconds: 500),
            baseColor: Colors.grey.shade100,
            highlightColor: Colors.grey.shade200,
            child: Container(
              color: Colors.white,
            ),
          );
        }
        if (_audioController.isNoneState) {
          return Center(
            child: Text('No song chosen'),
          );
        }
      }

      return _closeSheet(_mediaquary);
    }

    return WillPopScope(
      onWillPop: () async {
        if (_controller.isOpened) {
          _toggleplayersheet.bottomSheetfunction(true);
          _controller.hide();
          return false;
        }
        _toggleplayersheet.bottomSheetfunction(false);
        return true;
      },
      child: SolidBottomSheet(
        showOnAppear: false,
        smoothness: Smoothness.high,
        controller: _controller,
        maxHeight: _mediaquary.size.height,
        draggableBody: true,
        minHeight: 70,
        headerBar: SizedBox.shrink(),
        onHide: () => _isopen(false),
        onShow: () => _isopen(true),
        body: Obx(
          () => Material(
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.only(top: _isopen.value ? 0 : 20),
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          spreadRadius: 1.0,
                          blurRadius: 2.0),
                    ],
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _isopen.value
                              ? ColorList.lightcolors[
                                  _random.nextInt(ColorList.lightcolors.length)]
                              : Theme.of(context).scaffoldBackgroundColor,
                          Theme.of(context).scaffoldBackgroundColor
                        ]),
                  ),
                  child: _sheetbody(),
                ),
                _bigPicture(_mediaquary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned _bigPicture(MediaQueryData _mediaquary) {
    return Positioned(
      right: _isopen.value ? 0 : null,
      left: _isopen.value ? 0 : 0,
      top: _isopen.value ? _mediaquary.padding.top + 60 : 10,
      child: !_audioController.isNoneState
          ? Center(
              child: AnimatedContainer(
                curve: Curves.bounceOut,
                duration: Duration(milliseconds: 1000),
                clipBehavior: Clip.hardEdge,
                width: _isopen.value ? 300 : 62,
                height: _isopen.value ? 300 : 62,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(_isopen.value ? 5 : 5),
                    bottomRight: Radius.circular(_isopen.value ? 5 : 0),
                    topLeft: Radius.circular(_isopen.value ? 5 : 0),
                    bottomLeft: Radius.circular(_isopen.value ? 5 : 0),
                  ),
                ),
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Container(),
                  fit: BoxFit.cover,
                  imageUrl: ImageQuality.imageQuality(
                    value: _audioController
                        .currentMediaItem.value.extras!['imageUrl'],
                    size: 350,
                  ),
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Row _closeSheet(MediaQueryData _mediaquarry) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(left: 65, top: 5),
          width: _mediaquarry.size.width - 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _audioController.currentMediaItem.value.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  height: 1.2,
                  color: Color(0xFF333b66),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              Text(
                _audioController.currentMediaItem.value.artist!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  height: 1,
                  color: Color(0xFF333b66).withOpacity(.5),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Bounce(
          onPressed: () {
            _audioController.playPause();
          },
          duration: Duration(milliseconds: 200),
          child: Padding(
            padding: EdgeInsets.only(right: 10),
            child: FaIcon(
              _audioController.isPlaying.value
                  ? FontAwesomeIcons.pause
                  : FontAwesomeIcons.play,
              color: Color(0xFF333b66),
            ),
          ),
        )
      ],
    );
  }

  SingleChildScrollView _openSheet(MediaQueryData _mediaquary) {
    return SingleChildScrollView(
      child: SafeArea(
        child: SizedBox(
          height: _mediaquary.size.height - _mediaquary.padding.top,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              children: [
                SizedBox(
                  width: _mediaquary.size.width,
                  height: 35,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Bounce(
                          onPressed: () {
                            _controller.hide();
                          },
                          duration: Duration(milliseconds: 200),
                          child: Icon(
                            Icons.expand_more_rounded,
                            size: 40,
                            color: Color(0xFF333b66),
                          ),
                        ),
                      ),
                      Text(
                        'Now Playing',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF333b66),
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: _mediaquary.padding.top + 300,
                ),
                Text(
                  _audioController.currentMediaItem.value.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF333b66),
                    fontSize: 22,
                  ),
                ),
                Text(
                  "Track from ${_audioController.currentMediaItem.value.artist} from album ${_audioController.currentMediaItem.value.album} Released in ${_audioController.currentMediaItem.value.extras!['year']}",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333b66).withOpacity(.5),
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ProgressSlider(),
                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Bounce(
                              onPressed: () async {
                                await _audioController.skipToNext();
                              },
                              duration: Duration(milliseconds: 200),
                              child: FaIcon(
                                FontAwesomeIcons.backward,
                                color: Color(0xFF333b66),
                                size: 30,
                              ),
                            ),
                            Bounce(
                              onPressed: () async {
                                await _audioController.playPause();
                              },
                              duration: Duration(milliseconds: 200),
                              child: FaIcon(
                                _audioController.isPlaying.value
                                    ? FontAwesomeIcons.pause
                                    : FontAwesomeIcons.play,
                                color: Color(0xFF333b66),
                                size: 50,
                              ),
                            ),
                            Bounce(
                              onPressed: () async {
                                await _audioController.skipToNext();
                              },
                              duration: Duration(milliseconds: 200),
                              child: FaIcon(
                                FontAwesomeIcons.forward,
                                color: Color(0xFF333b66),
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
