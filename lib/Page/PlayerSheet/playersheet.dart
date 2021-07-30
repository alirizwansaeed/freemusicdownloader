import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freemusicdownloader/Controller/AudioPlayerController.dart';
import 'package:freemusicdownloader/Controller/DownloadController.dart';
import 'package:freemusicdownloader/Controller/TogglePlayerSheetController.dart';
import 'package:freemusicdownloader/Page/DownloadDialog/DownloadDialog.dart';
import 'package:freemusicdownloader/Page/PlayerSheet/ProgressSlider.dart';
import 'package:freemusicdownloader/Shared/ColorList.dart';
import 'package:freemusicdownloader/Shared/ImageQuality.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerSheet extends StatefulWidget {
  PlayerSheet({Key? key}) : super(key: key);

  @override
  _PlayerSheetState createState() => _PlayerSheetState();
}

class _PlayerSheetState extends State<PlayerSheet> {
  final _solidController = SolidController();
  final _toggleplayersheet = Get.find<TogglePlayersheetController>();
  final _audiocontroller = Get.find<AudioPlayerController>();
  final _downloadController = Get.find<DownloadController>();
  Rx<double> _heightStream = 60.0.obs;
  Random _random = Random();
  Color? _randomColor;
  @override
  void initState() {
    _randomColor =
        ColorList.lightcolors[_random.nextInt(ColorList.lightcolors.length)];
    _solidController.heightStream.listen((event) {
      _heightStream(event);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaquary = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (_solidController.isOpened) {
          _toggleplayersheet.bottomSheetfunction(true);
          _solidController.hide();
          return false;
        }
        _toggleplayersheet.bottomSheetfunction(false);
        return true;
      },
      child: SolidBottomSheet(
        showOnAppear: true,
        smoothness: Smoothness.high,
        controller: _solidController,
        maxHeight: _mediaquary.size.height,
        draggableBody: true,
        minHeight: 60,
        headerBar: SizedBox.shrink(),
        body: Obx(() => Opacity(
              opacity: _audiocontroller.currentPlayingSong.id == '' ? 0 : 1,
              child: Material(
                  color: Colors.transparent,
                  child: _openSheet(_mediaquary, _random)),
            )),
      ),
    );
  }

  Widget _openSheet(MediaQueryData _meidaquery, Random _random) {
    return Container(
      margin: EdgeInsets.only(
          top: ((_heightStream.value - 60.0) *
                      10 /
                      (_meidaquery.size.height - 60) -
                  10)
              .abs()),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black, spreadRadius: 1)],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _heightStream.value == 60 ? Colors.white : _randomColor!,
            Colors.white
          ],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: _meidaquery.padding.top,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity:
                  (_heightStream.value - 60.0) / (_meidaquery.size.height - 60),
              child: SizedBox(
                width: _meidaquery.size.width,
                height: 35,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Bounce(
                        onPressed: () {
                          _solidController.hide();
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
            ),
          ),
          Positioned(
            left: ((_heightStream.value - 60.0) *
                ((_meidaquery.size.width / 2) - 150) /
                (_meidaquery.size.height - 60.0)),
            top: ((_heightStream.value - 60.0) *
                    (_meidaquery.padding.top + 60) /
                    (_meidaquery.size.height - 60.0)) -
                10,
            height: ((_heightStream.value - 60.0) *
                    230 /
                    (_meidaquery.size.height - 60)) +
                60,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      (_heightStream.value - 60.0) *
                              (4) /
                              (_meidaquery.size.height - 60.0) +
                          2)),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                errorWidget: (context, url, error) => SizedBox.shrink(),
                imageUrl: ImageQuality.imageQuality(
                    value: _audiocontroller.currentPlayingSong.image,
                    size: 350),
              ),
            ),
          ),
          Positioned(
            right: (((_heightStream.value - 60.0) *
                        ((46)) /
                        (_meidaquery.size.height - 60.0)) -
                    40)
                .abs(),
            left: ((_heightStream.value - 60.0) *
                        (72) /
                        (_meidaquery.size.height - 60.0) -
                    66)
                .abs(),
            top: ((_heightStream.value - 60.0) *
                    (_meidaquery.padding.top + 350) /
                    (_meidaquery.size.height - 60.0)) +
                2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _audiocontroller.currentPlayingSong.song,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF333b66),
                    fontSize: ((_heightStream.value - 60.0) *
                            6 /
                            (_meidaquery.size.height - 60.0)) +
                        16,
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: Text(
                    "Track from ${_audiocontroller.currentPlayingSong.singers} from album ${_audiocontroller.currentPlayingSong.album} Released in ${_audiocontroller.currentPlayingSong.year}",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333b66).withOpacity(.5),
                      fontSize: 14,
                    ),
                  ),
                  secondChild: Text(
                    _audiocontroller.currentPlayingSong.singers,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333b66).withOpacity(.5),
                      fontSize: 14,
                    ),
                  ),
                  crossFadeState: ((_heightStream.value - 60.0) /
                              (_meidaquery.size.height - 60.0)) >
                          .5
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Duration(milliseconds: 1000),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 6,
            right: 6,
            child: Opacity(
              opacity: ((_heightStream.value - 60.0) /
                  (_meidaquery.size.height - 60.0)),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Bounce(
                          duration: Duration(milliseconds: 200),
                          onPressed: () async {
                            await _audiocontroller.shaffle();
                          },
                          child: FaIcon(
                            FontAwesomeIcons.random,
                            color: _audiocontroller.isshuffle
                                ? Color(0xFF333b66)
                                : Colors.grey,
                          ),
                        ),
                        Bounce(
                          duration: Duration(milliseconds: 200),
                          onPressed: () {
                            print(_audiocontroller
                                .currentPlayingSong.encryptedMediaUrl);
                            _downloadController.songSize(
                                _audiocontroller
                                    .currentPlayingSong.encryptedMediaUrl,
                                _audiocontroller.currentPlayingSong.the320Kbps);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DownloadDialog(
                                    songUrl: _audiocontroller
                                        .currentPlayingSong.encryptedMediaUrl,
                                    songName: _audiocontroller
                                        .currentPlayingSong.song);
                              },
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/download.svg',
                            color: Color(0xFF333b66),
                            height: 25,
                            width: 40,
                          ),
                        ),
                        Bounce(
                          duration: Duration(milliseconds: 200),
                          onPressed: () async {
                            await _audiocontroller.loop();
                          },
                          child: SvgPicture.asset(
                            _audiocontroller.loopmode == LoopMode.all
                                ? 'assets/arrows-repeat.svg'
                                : _audiocontroller.loopmode == LoopMode.one
                                    ? 'assets/arrows-repeat-1.svg'
                                    : 'assets/arrows-repeat.svg',
                            color: _audiocontroller.loopmode == LoopMode.off
                                ? Colors.grey
                                : Color(0xFF333b66),
                            height: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Opacity(
                    opacity: ((_heightStream.value - 60.0) /
                        (_meidaquery.size.height - 60.0)),
                    child: ProgressSlider(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Opacity(
                    opacity: ((_heightStream.value - 60.0) /
                        (_meidaquery.size.height - 60.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Bounce(
                          duration: Duration(milliseconds: 200),
                          onPressed: () {
                            _audiocontroller.previous();
                          },
                          child: FaIcon(
                            FontAwesomeIcons.backward,
                            color: Color(0xFF333b66),
                            size: 30,
                          ),
                        ),
                        Bounce(
                          duration: Duration(milliseconds: 200),
                          onPressed: () {
                            _audiocontroller.next();
                          },
                          child: FaIcon(
                            FontAwesomeIcons.forward,
                            color: Color(0xFF333b66),
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: ((_heightStream.value - 60.0) *
                    ((_meidaquery.size.width / 2 - 40)) /
                    (_meidaquery.size.height - 60.0)) +
                12,
            bottom: ((_heightStream.value - 60.0) *
                    ((10)) /
                    (_meidaquery.size.height - 60.0)) +
                6,
            child: Bounce(
              duration: Duration(milliseconds: 200),
              onPressed: () {
                _audiocontroller.playpause();
              },
              child: FaIcon(
                _audiocontroller.isplaying
                    ? FontAwesomeIcons.pause
                    : FontAwesomeIcons.play,
                color: Color(0xFF333b66),
                size: ((_heightStream.value - 60.0) *
                        25 /
                        (_meidaquery.size.height - 60.0)) +
                    35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
