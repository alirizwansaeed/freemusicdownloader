import 'dart:math';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freemusicdownloader/Controller/ApiController.dart';
import 'package:freemusicdownloader/Controller/DownloadController.dart';
import 'package:freemusicdownloader/Controller/TogglePlayerSheetController.dart';
import 'package:freemusicdownloader/Models/Search/TopSearchModel.dart';
import 'package:freemusicdownloader/Page/DownloadDialog/DownloadDialog.dart';
import 'package:freemusicdownloader/Page/SearchBar/pages/DetailAlbum.dart';
import 'package:freemusicdownloader/Page/SearchBar/pages/ViewAllSongs.dart';
import 'package:freemusicdownloader/Shared/ColorList.dart';
import 'package:freemusicdownloader/Shared/ImageQuality.dart';
import 'package:freemusicdownloader/Shared/ListTilesClipper.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

enum ViewFuctionType { NONE, SONG, ALBUM, PLAYLIST, ARTIST }

class SearchBar extends StatefulWidget {
  SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _apicontroller = Get.find<ApiController>();
  final _downloadController = Get.find<DownloadController>();
  final _toggleplayersheet = Get.find<TogglePlayersheetController>();
  final TextEditingController _searchController = TextEditingController();
  var controllertext = ''.obs;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _searchController.addListener(() {
      if (_searchController.text.length > 0) {
        controllertext(_searchController.text);
        _apicontroller.fetchTopsearch(_searchController.text);

      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          if (_toggleplayersheet.isBottomsheetopen.value == false) {
            if (!_apicontroller.topsearchCancelToken.isCancelled) {
              _apicontroller.topsearchCancelToken
                  .cancel('top search cancel by user');
            }
          
          }

          return _toggleplayersheet.isBottomsheetopen.value ? false : true;
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _searchbar(random),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 60, top: 20),
                    child: Column(
                      children: [
                        _apicontroller.topSearch.value.songs.isEmpty
                            ? SizedBox.shrink()
                            : _topSongs(random),
                        _apicontroller.topSearch.value.albums.isEmpty
                            ? SizedBox.shrink()
                            : _listView(
                                header: 'Top Albums',
                                random: random,
                                data: _apicontroller.topSearch.value.albums,
                                viewFuctionType: ViewFuctionType.ALBUM,
                              ),
                        _apicontroller.topSearch.value.playlists.isEmpty
                            ? SizedBox.shrink()
                            : _listView(
                                header: 'Top Playlists',
                                random: random,
                                data: _apicontroller.topSearch.value.playlists,
                                viewFuctionType: ViewFuctionType.PLAYLIST,
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _topSongs(Random random) {
    return Container(
      height: 210,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Songs',
                style: GoogleFonts.nunito(
                  color: Color(0xFF333b66),
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              BouncingWidget(
                onPressed: () async {
                  await Future.delayed(Duration(milliseconds: 300), () {
                    _apicontroller.fetchSearchDetail(
                        controllertext.value, 1, ViewFuctionType.SONG);
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: ViewAllSongs(
                          value: controllertext.value,
                        ),
                      ),
                    );
                  });
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.nunito(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _apicontroller.topSearch.value.songs.length,
              itemBuilder: (context, index) => Bounce(
                onPressed: () async {},
                duration: Duration(milliseconds: 100),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 0.0,
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
                              random.nextInt(ColorList.lightcolors.length)]
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
                              ImageQuality.imageQuality(
                                value: _apicontroller
                                    .topSearch.value.songs[index].image!,
                                size: 150,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          left: 45,
                          right: 40,
                          child: Text(
                            _apicontroller.topSearch.value.songs[index].title!,
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
                            _apicontroller
                                .topSearch.value.songs[index].description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: Bounce(
                            duration: Duration(milliseconds: 100),
                            onPressed: () async {
                              _focusNode.unfocus();
                              await _apicontroller.fetchSong(_apicontroller
                                  .topSearch.value.songs[index].id!);

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
            ),
          )
        ],
      ),
    );
  }

  Column _listView({
    required Random random,
    required List<SingleTopSearch> data,
    required String header,
    required ViewFuctionType viewFuctionType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              header,
              style: GoogleFonts.nunito(
                color: Color(0xFF333b66),
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            Bounce(
              duration: Duration(milliseconds: 200),
              onPressed: () => _detailpage(viewFuctionType),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'View All',
                  style: GoogleFonts.nunito(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 150,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            itemBuilder: (context, index) => Row(
              children: [
                Container(
                  width: 150,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipPath(
                        clipper: ListTilesClipper(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                              colors: [
                                ColorList.lightcolors[random
                                    .nextInt(ColorList.lightcolors.length)],
                                ColorList.lightcolors[random
                                    .nextInt(ColorList.lightcolors.length)],
                              ],
                            ),
                          ),
                        ),
                      ),
                      FlipCard(
                        back: Container(
                          padding: EdgeInsets.all(4.0),
                          margin:
                              EdgeInsets.only(right: 15, left: 15, bottom: 30),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: ColorList.primaries[
                                random.nextInt(ColorList.primaries.length)],
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            data[index].description!,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        front: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          margin: EdgeInsets.only(
                            right: 15,
                            left: 15,
                            bottom: 30,
                          ),
                          child: Image.network(
                            ImageQuality.imageQuality(
                                value: data[index].image!, size: 250),
                            errorBuilder: (context, error, stackTrace) =>
                                Container(),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        left: 5,
                        right: 5,
                        child: Center(
                          child: Text(
                            data[index].title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF333b66),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _searchbar(Random random) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              height: 40,
              child: TextField(
                autofocus: true,
                focusNode: _focusNode,
                controller: _searchController,
                decoration: InputDecoration(
                  labelStyle: GoogleFonts.nunito(
                    color: Colors.grey,
                  ),
                  labelText: 'Song, Album, Playlist',
                  contentPadding: EdgeInsets.only(top: 0, bottom: 25),
                  isDense: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(top: 10, left: 15),
                    child: FaIcon(
                      FontAwesomeIcons.search,
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
              onTap: () => Navigator.of(context).pop(), child: Text('Cancel'))
        ],
      ),
    );
  }

  void _detailpage(ViewFuctionType viewFuctionType) {
    _focusNode.unfocus();

    if (viewFuctionType == ViewFuctionType.ALBUM) {
      _apicontroller.fetchSearchDetail(
          controllertext.value, 1, ViewFuctionType.ALBUM);
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: ViewAllAlbums(
            value: controllertext.value,
            viewFuctionType: ViewFuctionType.ALBUM,
          ),
        ),
      );
    }
    if (viewFuctionType == ViewFuctionType.PLAYLIST) {
      _apicontroller.fetchSearchDetail(
          controllertext.value, 1, ViewFuctionType.PLAYLIST);
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: ViewAllAlbums(
            value: controllertext.value,
            viewFuctionType: ViewFuctionType.PLAYLIST,
          ),
        ),
      );
    }
  }

  void _downloadButton(BuildContext context, int index) {
    _downloadController.songSize(
        _apicontroller.singleSong.value.encryptedMediaUrl,
        _apicontroller.singleSong.value.the320Kbps);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DownloadDialog(
          songUrl: _apicontroller.singleSong.value.encryptedMediaUrl,
          songName: _apicontroller.singleSong.value.song,
        );
      },
    );
  }
}
