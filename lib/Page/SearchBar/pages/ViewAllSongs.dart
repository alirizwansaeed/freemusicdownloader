import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freemusicdownloader/Controller/DownloadController.dart';
import 'package:freemusicdownloader/Controller/TogglePlayerSheetController.dart';
import 'package:freemusicdownloader/Models/Search/ViewAllSongs.dart';
import 'package:freemusicdownloader/Page/DownloadDialog/DownloadDialog.dart';
import 'package:freemusicdownloader/Page/SearchBar/SearchBar.dart';
import 'package:freemusicdownloader/Shared/ColorList.dart';
import 'package:freemusicdownloader/Shared/PopButton.dart';
import 'package:get/get.dart';
import 'package:freemusicdownloader/Controller/ApiController.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewAllSongs extends StatefulWidget {
  final String value;
  const ViewAllSongs({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  _ViewAllSongsState createState() => _ViewAllSongsState();
}

class _ViewAllSongsState extends State<ViewAllSongs> {
  final _apicontroller = Get.find<ApiController>();
  final _scrollController = ScrollController();
  // final _audioplayerController = Get.find<AudioPlayerController>();
  final _downloadController = Get.find<DownloadController>();
  final _toggleplayersheet = Get.find<TogglePlayersheetController>();

  int pagenumber = 1;
  @override
  void initState() {
    _scrollController.addListener(scrollcontroller);
    super.initState();
  }

  void scrollcontroller() {
    if (_scrollController.position.extentAfter == 0) {
      _apicontroller.fetchSearchDetail(
          widget.value, ++pagenumber, ViewFuctionType.SONG);
      print('data');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Random _random = Random();
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          if (_toggleplayersheet.isBottomsheetopen.value == false) {
            _apicontroller.cancelToken.cancel('Detail Search request cancel');
            _apicontroller.detailSearch(ViewAllSongsModel());
          }

          return _toggleplayersheet.isBottomsheetopen.value ? false : true;
        },
        child: Material(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                leading: popButtom(
                    context,
                    ColorList.primaries[
                        _random.nextInt(ColorList.primaries.length)]),
                centerTitle: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  '${widget.value}',
                  maxLines: 1,
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333b66),
                  ),
                ),
                pinned: true,
                expandedHeight: 160,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(bottom: 10),
                  background: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Text(
                        _apicontroller.detailSearch.value.total.toString() +
                            ' Songs',
                        style: GoogleFonts.nunito(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333b66)),
                      ),
                    ),
                  ),
                  centerTitle: true,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => Bounce(
                    onPressed: () async {},
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
                              Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0),
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
                                padding: EdgeInsets.only(right: 1),
                                foregroundDecoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    stops: [0.6, .95],
                                    colors: [
                                      Colors.white.withOpacity(0.0),
                                      Theme.of(context).scaffoldBackgroundColor
                                    ],
                                  ),
                                ),
                                height: 50,
                                width: 50,
                                child: Image.network(
                                  _apicontroller
                                      .detailSearch.value.results[index].image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              left: 45,
                              right: 40,
                              child: Text(
                                _apicontroller
                                    .detailSearch.value.results[index].title!,
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
                              left: 45,
                              right: 40,
                              child: Text(
                                _apicontroller.detailSearch.value.results[index]
                                    .subtitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: Bounce(
                                duration: Duration(milliseconds: 100),
                                onPressed: () async {
                                  _downloadButton(context, index);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  height: 50,
                                  width: 40,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10, top: 5, bottom: 10),
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
                  childCount: _apicontroller.detailSearch.value.results.length,
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(bottom: 60),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _downloadButton(BuildContext context, int index) {
    _downloadController.songSize(
        _apicontroller
            .detailSearch.value.results[index].moreInfo!.encryptedMediaUrl!,
        _apicontroller.detailSearch.value.results[index].moreInfo!.the320Kbps!);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DownloadDialog(
          songUrl: _apicontroller
              .detailSearch.value.results[index].moreInfo!.encryptedMediaUrl!,
          songName: _apicontroller.detailSearch.value.results[index].title!,
        );
      },
    );
  }
}
