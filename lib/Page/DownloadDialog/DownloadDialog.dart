import 'dart:async';
import 'dart:math';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:freemusicdownloader/Controller/DownloadController.dart';
import 'package:freemusicdownloader/Page/DownloadDialog/PrgressBar.dart';
import 'package:freemusicdownloader/Shared/ColorList.dart';

StatusBloc slimyCard = StatusBloc();

class DownloadDialog extends StatefulWidget {
  final String songName;
  final String songUrl;
  const DownloadDialog({
    Key? key,
    required this.songName,
    required this.songUrl,
  }) : super(key: key);
  @override
  _DownloadDialogState createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog>
    with TickerProviderStateMixin {
  bool? isSeperated;
  double? bottomDimension;
  double? initialBottomDimension;
  double? finalBottomDimension;
  double? gap;
  double? gapInitial;
  double? gapFinal;
  double? x;
  double? y;
  String? activeAnimation;
  final width = 300.0;
  final topCardHeight = 150.0;
  final bottomCardHeight = 60.0;
  final borderRadius = 5.0;
  final slimeEnabled = true;
  Color color = Colors.blue;

  Animation<double>? arrowAnimation;
  AnimationController? arrowAnimController;
  final _downloadController = Get.find<DownloadController>();
  Random _random = Random();

  @override
  void dispose() {
    arrowAnimController!.dispose();

    super.dispose();
  }

  @override
  void initState() {
    color = ColorList.primaries[_random.nextInt(ColorList.primaries.length)];
    isSeperated = false;
    activeAnimation = 'Idle';
    initialBottomDimension = 100;
    finalBottomDimension = bottomCardHeight;
    bottomDimension = initialBottomDimension;
    arrowAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    arrowAnimation =
        Tween<double>(begin: 0, end: 0.5).animate(arrowAnimController!);
    super.initState();
  }

  void farwardAnimation() async {
    activeAnimation = (activeAnimation == 'Idle') ? 'Action' : 'Idle';
    arrowAnimController!.forward();
    isSeperated = true;
    slimyCard.updateStatus(true);
    gap = gapFinal;
    bottomDimension = finalBottomDimension;
  }

  void reverseAnimation() {
    activeAnimation = (activeAnimation == 'Idle') ? 'Action' : 'Idle';
    isSeperated = false;
    slimyCard.updateStatus(false);
    arrowAnimController!.reverse();
    gap = gapInitial;
    bottomDimension = initialBottomDimension;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    x = (borderRadius < 10) ? 10 : borderRadius;
    y = (borderRadius < 2) ? 2 : borderRadius;
    gapInitial = ((topCardHeight - x! - width / 4) > 0)
        ? (topCardHeight - x! - width / 4)
        : 0;
    gapFinal = ((topCardHeight + x! - width / 4 + 50) > 0)
        ? (topCardHeight + x! - width / 4 + 50)
        : 2 * x! + 50;
    gap = gapInitial;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      elevation: 0.0,
      buttonPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      actions: [
        Container(
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Column(
                children: <Widget>[
                  AnimatedContainer(
                    duration: Duration(milliseconds: 1800),
                    height: gap,
                    curve: Curves.elasticOut,
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Container(
                        height: bottomDimension,
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        alignment: Alignment.center,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 100),
                          opacity: (isSeperated!) ? 1.0 : 0,
                          child: _bottomContainer(),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: FlareActor(
                              'assets/bottomSlime.flr',
                              color: color.withOpacity((slimeEnabled) ? 1 : 0),
                              animation: activeAnimation,
                              sizeFromArtboard: true,
                              alignment: Alignment.bottomCenter,
                              fit: BoxFit.contain,
                            ),
                            height: width / 4,
                            width: width,
                          ),
                          SizedBox(
                            height: bottomDimension! - (x!),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    height: topCardHeight,
                    width: width,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: _topContainer(),
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: ((topCardHeight - y!) > 0)
                            ? (topCardHeight - y!)
                            : 0,
                      ),
                      Container(
                        height: width / 4,
                        width: width,
                        child: FlareActor(
                          'assets/topSlime.flr',
                          color: color.withOpacity((slimeEnabled) ? 1 : 0),
                          animation: activeAnimation,
                          sizeFromArtboard: true,
                          alignment: Alignment.topCenter,
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: ((topCardHeight - 2 * 50 / 3) > 0)
                        ? (topCardHeight - 2 * 50 / 3)
                        : 0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _topContainer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Bounce(
            duration: Duration(milliseconds: 200),
            onPressed: () {
              _downloadController.songSizeCancelToken();
              _downloadController.downloadCancelToken();
              Navigator.of(context).pop();
            },
            child: FaIcon(
              FontAwesomeIcons.times,
              color: Colors.white,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Text(
                widget.songName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            Obx(() => AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: _downloadController.progress.value == 1.0 ? 0 : 1,
                  child: Text(
                    'Choose Qaulity',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                )),
            Obx(() {
              if (_downloadController.progress.value == 1.0) {
                return Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Saved in Phone/Music/Floovi Music',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else
                return Wrap(
                  children: [
                    Bounce(
                      duration: Duration(milliseconds: 200),
                      onPressed: () async {
                        _downloadController.downloadCancelToken();

                        _downloadController.downloadSong(
                            url: widget.songUrl,
                            name: widget.songName,
                            quality: '96kbps');
                        setState(() {
                          farwardAnimation();
                        });
                      },
                      child: Card(
                        child: SizedBox(
                          height: 60,
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '96 Kbps',
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333b66),
                                    fontSize: 14),
                              ),
                              Text(
                                '${_downloadController.kbps96}',
                                style: GoogleFonts.nunito(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Bounce(
                      duration: Duration(milliseconds: 200),
                      onPressed: () {
                        _downloadController.downloadCancelToken();
                        _downloadController.downloadSong(
                            url: widget.songUrl
                                .replaceAll('_96.mp4', '_160.mp4'),
                            name: widget.songName,
                            quality: '160kbps');
                        setState(() {
                          farwardAnimation();
                        });
                      },
                      child: Card(
                        child: SizedBox(
                          height: 60,
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '160 Kbps',
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333b66),
                                    fontSize: 14),
                              ),
                              Text(
                                '${_downloadController.kbps160}',
                                style: GoogleFonts.nunito(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Bounce(
                      duration: Duration(milliseconds: 200),
                      onPressed: () {
                        _downloadController.downloadCancelToken();

                        _downloadController.downloadSong(
                            url: widget.songUrl
                                .replaceAll('_96.mp4', '_320.mp4'),
                            name: widget.songName,
                            quality: '320kbps');
                        setState(() {
                          farwardAnimation();
                        });
                      },
                      child: Card(
                        child: SizedBox(
                          height: 60,
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '320Kbps',
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333b66),
                                    fontSize: 14),
                              ),
                              Text(
                                '${_downloadController.kbps320}',
                                style: GoogleFonts.nunito(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
            }),
          ],
        ),
      ],
    );
  }

  Widget _bottomContainer() {
    return ProgressBar(
      randomcolor: color,
    );
  }
}

/// This is stream(according to BLoC) which enables to update real-time status
/// of SlimyCard
class StatusBloc {
  var statusController = StreamController<bool>.broadcast();
  Function(bool) get updateStatus => statusController.sink.add;
  Stream<bool> get stream => statusController.stream;

  dispose() {
    statusController.close();
  }
}
