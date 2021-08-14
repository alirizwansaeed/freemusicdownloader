import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:freemusicdownloader/Controller/TogglePlayerSheetController.dart';
import 'package:freemusicdownloader/Models/Search/ViewAllSongs.dart';
import 'package:freemusicdownloader/Page/playlist.dart/playlist.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:page_transition/page_transition.dart';

import 'package:freemusicdownloader/Controller/ApiController.dart';
import 'package:freemusicdownloader/Page/Album/Albums.dart';
import 'package:freemusicdownloader/Page/SearchBar/SearchBar.dart';
import 'package:freemusicdownloader/Shared/ColorList.dart';
import 'package:freemusicdownloader/Shared/ImageQuality.dart';
import 'package:freemusicdownloader/Shared/ListTilesClipper.dart';
import 'package:freemusicdownloader/Shared/PopButton.dart';

class ViewAllAlbums extends StatelessWidget {
  final ViewFuctionType viewFuctionType;
  final String value;
  ViewAllAlbums({
    Key? key,
    required this.viewFuctionType,
    required this.value,
  }) : super(key: key);

  final _apicontroller = Get.find<ApiController>();
  final _scrollController = ScrollController();
  final _toggleplayersheet = Get.find<TogglePlayersheetController>();

  @override
  Widget build(BuildContext context) {
    Random _random = Random();
    int pagenumber = 1;
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          if (_toggleplayersheet.isBottomsheetopen.value == false) {
            if (!_apicontroller.cancelToken.isCancelled)
              _apicontroller.cancelToken.cancel('Detail Search request cancel');
            _apicontroller.detailSearch(ViewAllSongsModel());
          }

          return _toggleplayersheet.isBottomsheetopen.value ? false : true;
        },
        child: Material(
          child: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: CustomScrollView(
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
                    value,
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
                              '${viewFuctionType == ViewFuctionType.ALBUM ? ' Album' : ' Playlists'} ',
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
                SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 2,
                  itemCount: _apicontroller.detailSearch.value.results.length,
                  staggeredTileBuilder: (int index) =>
                      StaggeredTile.count(1, 1),
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 8.0,
                  itemBuilder: (BuildContext context, int index) =>
                      LazyLoadingList(
                    index: index,
                    initialSizeOfItems:
                        _apicontroller.detailSearch.value.results.length,
                    hasMore: true,
                    loadMore: () {
                      if (viewFuctionType == ViewFuctionType.ALBUM) {
                        _apicontroller.fetchSearchDetail(
                            value, ++pagenumber, ViewFuctionType.ALBUM);
                      }
                      _apicontroller.fetchSearchDetail(
                          value, ++pagenumber, ViewFuctionType.PLAYLIST);
                    },
                    child: Bounce(
                      duration: Duration(milliseconds: 200),
                      onPressed: () async {
                        if (viewFuctionType == ViewFuctionType.ALBUM) {
                          _apicontroller.fetchAlbum(_apicontroller
                              .detailSearch.value.results[index].id!);
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRight,
                              child: Album(),
                              settings: RouteSettings(
                                arguments: {
                                  "image": _apicontroller
                                      .detailSearch.value.results[index].image!,
                                  "title": _apicontroller
                                      .detailSearch.value.results[index].title!,
                                  "id": _apicontroller
                                      .detailSearch.value.results[index].id!,
                                },
                              ),
                            ),
                          );
                        } else {
                          _apicontroller.fetchPlaylist(_apicontroller
                              .detailSearch.value.results[index].id!);
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRight,
                              child: Playlist(),
                              settings: RouteSettings(
                                arguments: {
                                  "image": _apicontroller
                                      .detailSearch.value.results[index].image!,
                                  "title": _apicontroller
                                      .detailSearch.value.results[index].title!,
                                  "id": _apicontroller
                                      .detailSearch.value.results[index].id!,
                                },
                              ),
                            ),
                          );
                        }
                      },
                      child: _girdTiles(_random, index),
                    ),
                  ),
                ),
                SliverPadding(padding: EdgeInsets.only(top: 50))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack _girdTiles(Random random, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipPath(
          clipper: ListTilesClipper(),
          child: Container(
            margin: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                colors: [
                  ColorList.lightcolors[
                      random.nextInt(ColorList.lightcolors.length)],
                  ColorList.lightcolors[
                      random.nextInt(ColorList.lightcolors.length)],
                ],
              ),
            ),
          ),
        ),
        Hero(
          tag: _apicontroller.detailSearch.value.results[index].id!,
          child: FlipCard(
            back: Container(
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorList
                    .primaries[random.nextInt(ColorList.primaries.length)],
              ),
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.only(right: 25, left: 25, bottom: 50),
              child: Text(
                _apicontroller.detailSearch.value.results[index].subtitle??'' +
                    ' Year:' +
                    _apicontroller.detailSearch.value.results[index].year,
                style: TextStyle(color: Colors.white),
              ),
            ),
            front: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.only(right: 25, left: 25, bottom: 50),
              child: CachedNetworkImage(
                imageUrl: ImageQuality.imageQuality(
                  value:
                      _apicontroller.detailSearch.value.results[index].image!,
                  size: 350,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 25,
          left: 5,
          right: 5,
          child: Center(
            child: Text(
              _apicontroller.detailSearch.value.results[index].title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w900, color: Color(0xFF333b66)),
            ),
          ),
        ),
      ],
    );
  }
}
