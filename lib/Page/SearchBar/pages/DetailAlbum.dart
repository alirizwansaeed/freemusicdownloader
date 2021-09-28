import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:freemusicdownloader/Controller/TogglePlayerSheetController.dart';
import 'package:freemusicdownloader/Page/playlist.dart/playlist.dart';
import 'package:freemusicdownloader/Shared/ImagePlaceHolder.dart';
import 'package:freemusicdownloader/Shared/loading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:page_transition/page_transition.dart';
import 'package:freemusicdownloader/Controller/ApiController.dart';
import 'package:freemusicdownloader/Page/Album/Albums.dart';
import 'package:freemusicdownloader/Page/SearchBar/SearchBar.dart';
import 'package:freemusicdownloader/Shared/ImageQuality.dart';
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
          }

          return _toggleplayersheet.isBottomsheetopen.value ? false : true;
        },
        child: Material(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              notification.disallowGlow();
              return true;
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  elevation: 0.0,
                  leading: popButtom(
                    context,
                  ),
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
                  flexibleSpace: _apicontroller.isloading.value
                      ? null
                      : FlexibleSpaceBar(
                          titlePadding: EdgeInsets.only(bottom: 10),
                          background: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Text(
                                _apicontroller.detailSearch.value.total
                                        .toString() +
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
                _apicontroller.isloading.value
                    ? SliverPadding(
                        padding: EdgeInsets.only(top: Get.height / 2 - 200),
                        sliver: SliverToBoxAdapter(child: loading()))
                    : SliverPadding(
                        padding: EdgeInsets.only(right: 8, left: 8),
                        sliver: SliverStaggeredGrid.countBuilder(
                          crossAxisCount: 2,
                          itemCount:
                              _apicontroller.detailSearch.value.results.length,
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.count(1, 1.12),
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 8.0,
                          itemBuilder: (BuildContext context, int index) =>
                              LazyLoadingList(
                            index: index,
                            initialSizeOfItems: _apicontroller
                                .detailSearch.value.results.length,
                            hasMore: true,
                            loadMore: () {
                              if (viewFuctionType == ViewFuctionType.ALBUM) {
                                _apicontroller.fetchSearchDetail(
                                    value, ++pagenumber, ViewFuctionType.ALBUM);
                              }
                              _apicontroller.fetchSearchDetail(value,
                                  ++pagenumber, ViewFuctionType.PLAYLIST);
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
                                          "image": _apicontroller.detailSearch
                                              .value.results[index].image!,
                                          "title": _apicontroller.detailSearch
                                              .value.results[index].title!,
                                          "id": _apicontroller.detailSearch
                                              .value.results[index].id!,
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
                                          "image": _apicontroller.detailSearch
                                              .value.results[index].image!,
                                          "title": _apicontroller.detailSearch
                                              .value.results[index].title!,
                                          "id": _apicontroller.detailSearch
                                              .value.results[index].id!,
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
                      ),
                SliverPadding(padding: EdgeInsets.only(top: 50))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _girdTiles(Random random, int index) {
    return Column(
      children: [
        Expanded(
          child: Hero(
            tag: _apicontroller.detailSearch.value.results[index].id!,
            child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(4)),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl: ImageQuality.imageQuality(
                      value: _apicontroller
                          .detailSearch.value.results[index].image!,
                      size: 350),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  placeholder: (context, url) => imagePlaceHolder(),
                  errorWidget: (context, url, error) => imagePlaceHolder(),
                ),
              ),
          ),
        ),
        SizedBox(height: 6.0),
        Text(
          _apicontroller.detailSearch.value.results[index].title!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
