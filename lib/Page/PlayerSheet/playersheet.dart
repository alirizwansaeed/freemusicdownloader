import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:freemusicdownloader/Page/PlayerSheet/ProgressSlider.dart';
import 'package:freemusicdownloader/Controller/AudioPlayerController.dart';
import 'package:freemusicdownloader/Controller/TogglePlayerSheetController.dart';
import 'package:freemusicdownloader/Shared/GradientColorList.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerSheet extends StatefulWidget {
  PlayerSheet({Key? key}) : super(key: key);

  @override
  _PlayerSheetState createState() => _PlayerSheetState();
}

class _PlayerSheetState extends State<PlayerSheet> {
  AudioplayerController _audioplayerService = Get.find<AudioplayerController>();
  SolidController _controller = SolidController();
  TogglePlayersheetController _toggleplayersheet =
      Get.find<TogglePlayersheetController>();

  Rx<bool> _isopen = false.obs;
  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaquary = MediaQuery.of(context);
    Random _random = Random();
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
        showOnAppear: true,
        smoothness: Smoothness.high,
        controller: _controller,
        maxHeight: _mediaquary.size.height,
        draggableBody: true,
        minHeight: 70,
        headerBar: Container(
          height: 10,
        ),
        onHide: () => _isopen(false),
        onShow: () => _isopen(true),
        body: Obx(
          () => AnimatedOpacity(
            opacity: _audioplayerService.isPlayerinitilized.value ? 1 : 0,
            duration: Duration(milliseconds: 200),
            child: Material(
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.only(top: _isopen.value ? 0 : 20),
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [
                            0.0,
                            .5
                          ],
                          colors: [
                            // Colors.primaries[
                            //     _random.nextInt(Colors.primaries.length)],
                            ColorList.colorList[
                                _random.nextInt(ColorList.colorList.length)],
                            Theme.of(context).scaffoldBackgroundColor
                          ]),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: _isopen.value
                        ? SingleChildScrollView(
                            child: SafeArea(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.expand_more_rounded,
                                        size: 40,
                                        color: Color(0xFF333b66),
                                      ),
                                      Spacer(),
                                      Text(
                                        'Now Playing',
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF333b66),
                                          fontSize: 24,
                                        ),
                                      ),
                                      Spacer(
                                        flex: 2,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 290,
                                  ),
                                  Text(
                                    'Now Playing tum dil ki dharkan me reht ho ',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF333b66),
                                      fontSize: 22,
                                    ),
                                  ),
                                  Text(
                                    "Track from kabiir sing form album tuje kitna chahny lagy hian ham & Released in 1990",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333b66).withOpacity(.5),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Container(
                                    height: _mediaquary.size.height -
                                        (530 - _mediaquary.padding.top),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ProgressSlider(),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Stack(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Bounce(
                                                  onPressed: _audioplayerService
                                                      .previousButtonSong,
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                  child: FaIcon(
                                                    FontAwesomeIcons.backward,
                                                    color: Color(0xFF333b66),
                                                    size: 30,
                                                  ),
                                                ),
                                                Bounce(
                                                  onPressed: _audioplayerService
                                                      .playPauseButton,
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                  child: FaIcon(
                                                    _audioplayerService
                                                            .isplaying.value
                                                        ? FontAwesomeIcons.pause
                                                        : FontAwesomeIcons.play,
                                                    color: Color(0xFF333b66),
                                                    size: 50,
                                                  ),
                                                ),
                                                Bounce(
                                                  onPressed: _audioplayerService
                                                      .nextSongButton,
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                  child: FaIcon(
                                                    FontAwesomeIcons.forward,
                                                    color: Color(0xFF333b66),
                                                    size: 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Positioned(
                                                right: 4,
                                                top: 10,
                                                child: FaIcon(
                                                  FontAwesomeIcons.download,
                                                  color: Color(0xFF333b66),
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 60),
                                      child: Text(
                                        'Is tarha sa ashqui ka asar',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.nunito(
                                          height: 1.2,
                                          color: Color(0xFF333b66),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 60),
                                      child: Text(
                                        'Is tarha sa ashqui ka asar',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          height: 1,
                                          color:
                                              Color(0xFF333b66).withOpacity(.5),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Bounce(
                                  onPressed: () {
                                    _audioplayerService.playPauseButton();
                                  },
                                  duration: Duration(milliseconds: 200),
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: FaIcon(
                                      _audioplayerService.isplaying.value
                                          ? FontAwesomeIcons.pause
                                          : FontAwesomeIcons.play,
                                      color: Color(0xFF333b66),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
                  Positioned(
                    left: _isopen.value ? _mediaquary.size.width / 2 - 125 : 0,
                    top: _isopen.value ? _mediaquary.padding.top + 60 : 10,
                    child: Obx(
                      () => AnimatedContainer(
                        curve: Curves.bounceOut,
                        duration: Duration(milliseconds: 1000),
                        clipBehavior: Clip.hardEdge,
                        width: _isopen.value ? 250 : 62,
                        height: _isopen.value ? 250 : 62,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(_isopen.value ? 5 : 5),
                            bottomRight: Radius.circular(_isopen.value ? 5 : 0),
                            topLeft: Radius.circular(_isopen.value ? 5 : 0),
                            bottomLeft: Radius.circular(_isopen.value ? 5 : 0),
                          ),
                        ),
                        child: CachedNetworkImage(
                          errorWidget: (context, url, error) => Container(),
                          fit: BoxFit.cover,
                          imageUrl:
                              _audioplayerService.songProperties.value.image,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
