import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freemusicdownloader/Controller/AudioPlayerController.dart';
import 'package:freemusicdownloader/Controller/TogglePlayerSheetController.dart';
import 'package:freemusicdownloader/Models/SingleSong.dart';
import 'package:freemusicdownloader/Page/DownloadDialog/DownloadSong.dart';
import 'package:freemusicdownloader/Page/SearchBar/SearchBar.dart';
import 'package:freemusicdownloader/Shared/ImagePlaceHolder.dart';
import 'package:freemusicdownloader/Shared/ImageQuality.dart';
import 'package:freemusicdownloader/Shared/PopButton.dart';
import 'package:freemusicdownloader/Shared/loading.dart';
import 'package:get/get.dart';
import 'package:freemusicdownloader/Controller/ApiController.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';

class ViewAllSongs extends StatelessWidget {
  final String value;
  ViewAllSongs({
    Key? key,
    required this.value,
  }) : super(key: key);

  final _apicontroller = Get.find<ApiController>();
  final _audioplayerController = Get.find<AudioPlayerController>();
  final _toggleplayersheet = Get.find<TogglePlayersheetController>();

  @override
  Widget build(BuildContext context) {
    int pagenumber = 1;
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          if (_toggleplayersheet.isBottomsheetopen.value == false) {
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
              physics: ClampingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  leading: popButtom(
                    context,
                  ),
                  centerTitle: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: Text(
                    '$value',
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
                _apicontroller.isloading.value
                    ? SliverPadding(
                        padding: EdgeInsets.only(top: Get.height / 2 - 200),
                        sliver: SliverToBoxAdapter(child: loading()))
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) => LazyLoadingList(
                            index: index,
                            hasMore: true,
                            initialSizeOfItems: _apicontroller
                                .detailSearch.value.results.length,
                            loadMore: () {
                              _apicontroller.fetchSearchDetail(
                                  value, ++pagenumber, ViewFuctionType.SONG);
                            },
                            child: ListTile(
                              onTap: () {
                                _audioplayerController.loadSong([
                                  Song(
                                    album: _apicontroller.detailSearch.value
                                            .results[index].moreInfo!.album ??
                                        '',
                                    encryptedMediaUrl: _apicontroller
                                            .detailSearch
                                            .value
                                            .results[index]
                                            .moreInfo!
                                            .encryptedMediaUrl ??
                                        '',
                                    image: _apicontroller.detailSearch.value
                                            .results[index].image ??
                                        '',
                                    singers: _apicontroller.detailSearch.value
                                        .results[index].subtitle!
                                        .split('-')[0],
                                    song: _apicontroller.detailSearch.value
                                            .results[index].title ??
                                        "",
                                    the320Kbps: _apicontroller
                                            .detailSearch
                                            .value
                                            .results[index]
                                            .moreInfo!
                                            .the320Kbps ??
                                        "",
                                    id: _apicontroller.detailSearch.value
                                            .results[index].id ??
                                        "",
                                    year: _apicontroller
                                        .detailSearch.value.results[index].year,
                                  )
                                ], 0, '');
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
                                    value: _apicontroller.detailSearch.value
                                        .results[index].image!,
                                    size: 150,
                                  ),
                                  placeholder: (context, url) =>
                                      imagePlaceHolder(),
                                  errorWidget: (context, url, error) =>
                                      imagePlaceHolder(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                _apicontroller
                                    .detailSearch.value.results[index].title!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                _apicontroller.detailSearch.value.results[index]
                                    .subtitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: BouncingWidget(
                                onPressed: () {
                                  Get.bottomSheet(DownloadSong(
                                    songName: _apicontroller.detailSearch.value
                                            .results[index].title ??
                                        '',
                                    songUrl: _apicontroller
                                        .detailSearch
                                        .value
                                        .results[index]
                                        .moreInfo!
                                        .encryptedMediaUrl!,
                                    is320: _apicontroller.detailSearch.value
                                        .results[index].moreInfo!.the320Kbps!,
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
                          ),
                          childCount:
                              _apicontroller.detailSearch.value.results.length,
                        ),
                      ),
                SliverPadding(
                  padding: EdgeInsets.only(bottom: 60),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
