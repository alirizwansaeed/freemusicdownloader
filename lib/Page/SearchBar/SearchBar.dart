import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freemusicdownloader/Controller/ApiController.dart';
import 'package:freemusicdownloader/Controller/AudioPlayerController.dart';
import 'package:freemusicdownloader/Controller/TogglePlayerSheetController.dart';
import 'package:freemusicdownloader/Models/Search/TopSearchModel.dart';
import 'package:freemusicdownloader/Page/Album/Albums.dart';
import 'package:freemusicdownloader/Page/DownloadDialog/DownloadSong.dart';
import 'package:freemusicdownloader/Page/SearchBar/pages/DetailAlbum.dart';
import 'package:freemusicdownloader/Page/SearchBar/pages/ViewAllSongs.dart';
import 'package:freemusicdownloader/Page/playlist.dart/playlist.dart';
import 'package:freemusicdownloader/Shared/ImagePlaceHolder.dart';
import 'package:freemusicdownloader/Shared/ImageQuality.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

enum ViewFuctionType { NONE, SONG, ALBUM, PLAYLIST, ARTIST }

class SearchBar extends StatefulWidget {
  SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _apicontroller = Get.find<ApiController>();
  final _toggleplayersheet = Get.find<TogglePlayersheetController>();
  final TextEditingController _searchController = TextEditingController();
  final _audioController = Get.find<AudioPlayerController>();
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
    return WillPopScope(
      onWillPop: () async {
        if (_toggleplayersheet.isBottomsheetopen.value == false) {
          if (!_apicontroller.topsearchCancelToken.isCancelled) {
            _apicontroller.topsearchCancelToken
                .cancel('top search cancel by user');
          }
        }

        return _toggleplayersheet.isBottomsheetopen.value ? false : true;
      },
      child: Material(
        child: SafeArea(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                _searchbar(),
                _apicontroller.topSearch.value == TopSearchModel()
                    ? Lottie.asset(
                        'assets/search_background.json',
                      )
                    : NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (notification) {
                          notification.disallowGlow();
                          return true;
                        },
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 60, top: 20),
                          child: Column(
                            children: [
                              _apicontroller.topSearch.value.songs == null
                                  ? SizedBox.shrink()
                                  : _header('Top Songs', ViewFuctionType.SONG),
                              _topSongs(),
                              _apicontroller.topSearch.value.albums == null
                                  ? SizedBox.shrink()
                                  : _header(
                                      'Top Albums', ViewFuctionType.ALBUM),
                              _listView(
                                data:
                                    _apicontroller.topSearch.value.albums ?? [],
                                viewFuctionType: ViewFuctionType.ALBUM,
                              ),
                              _apicontroller.topSearch.value.playlists == null
                                  ? SizedBox.shrink()
                                  : _header('Top Playlists',
                                      ViewFuctionType.PLAYLIST),
                              _listView(
                                data:
                                    _apicontroller.topSearch.value.playlists ??
                                        [],
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

  Widget _header(String header, ViewFuctionType viewFuctionType) {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              header,
              style: TextStyle(
                  color: Color(0xFF333b66),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            BouncingWidget(
              onPressed: () async {
                await Future.delayed(Duration(milliseconds: 300), () {
                  _detailpage(viewFuctionType);
                });
              },
              child: Text(
                'View All',
                style: GoogleFonts.nunito(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topSongs() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: _apicontroller.topSearch.value.songs!.length,
        itemBuilder: (context, index) => ListTile(
          onTap: () async {
            _focusNode.unfocus();
            await _apicontroller
                .fetchSong(_apicontroller.topSearch.value.songs![index].id!);

            _audioController.loadSong([_apicontroller.singleSong.value], 0, '');
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
                value: _apicontroller.topSearch.value.songs![index].image!,
                size: 150,
              ),
              placeholder: (context, url) => imagePlaceHolder(),
              errorWidget: (context, url, error) => imagePlaceHolder(),
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            _apicontroller.topSearch.value.songs![index].title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            _apicontroller.topSearch.value.songs![index].description!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Bounce(
            duration: Duration(milliseconds: 100),
            onPressed: () async {
              _focusNode.unfocus();
              await _apicontroller
                  .fetchSong(_apicontroller.topSearch.value.songs![index].id!);
              Get.bottomSheet(
                DownloadSong(
                    songName: _apicontroller.singleSong.value.song,
                    songUrl: _apicontroller.singleSong.value.encryptedMediaUrl,
                    is320: _apicontroller.singleSong.value.the320Kbps),
              );
            },
            child: SvgPicture.asset(
              'assets/download.svg',
              color: Colors.grey.shade600,
              height: 23,
              width: 23,
            ),
          ),
        ),
      ),
    );
  }

  Widget _listView({
    required List<SingleTopSearch> data,
    required ViewFuctionType viewFuctionType,
  }) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) => Bounce(
          duration: Duration(milliseconds: 200),
          onPressed: () {
            if (viewFuctionType == ViewFuctionType.ALBUM) {
              _apicontroller.fetchAlbum(data[index].id!);
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: Album(),
                  settings: RouteSettings(
                    arguments: {
                      "image": data[index].image,
                      "title": data[index].title,
                      "id": data[index].id,
                    },
                  ),
                ),
              );
            }
            if (viewFuctionType == ViewFuctionType.PLAYLIST) {
              _apicontroller.fetchPlaylist(data[index].id!);
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: Playlist(),
                  settings: RouteSettings(
                    arguments: {
                      "image": data[index].image,
                      "title": data[index].title,
                      "id": data[index].id,
                    },
                  ),
                ),
              );
            }
          },
          child: Container(
            width: 130,
            child: Column(
              children: [
                Container(
                    height: 120,
                    width: 120,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: ImageQuality.imageQuality(
                          value: data[index].image!, size: 350),
                      errorWidget: (context, url, error) => imagePlaceHolder(),
                      placeholder: (context, url) => imagePlaceHolder(),
                      fit: BoxFit.cover,
                    ),
                  ),     
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Center(
                    child: Text(data[index].title!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchbar() {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                // autofocus: true,
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
            SizedBox(
              width: 6,
            ),
            GestureDetector(
                onTap: () => Navigator.of(context).pop(), child: Text('Cancel'))
          ],
        ),
      ),
    );
  }

  void _detailpage(ViewFuctionType viewFuctionType) {
    _focusNode.unfocus();
    if (viewFuctionType == ViewFuctionType.SONG) {
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
    }
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
}
