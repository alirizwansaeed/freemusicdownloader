import 'package:dio/dio.dart';
import 'package:freemusicdownloader/Models/MainPageModel.dart';
import 'package:freemusicdownloader/Models/PlaylistModel.dart';
import 'package:freemusicdownloader/Models/AlbumModel.dart';
import 'package:freemusicdownloader/Models/Search/TopSearchModel.dart';
import 'package:freemusicdownloader/Models/Search/ViewAllSongs.dart';
import 'package:freemusicdownloader/Models/SingleSong.dart';
import 'package:freemusicdownloader/Page/SearchBar/SearchBar.dart';
import 'package:freemusicdownloader/Services/ApiService.dart';
import 'package:get/get.dart';

class ApiController extends GetxController {
  var isloading = false.obs;
  CancelToken get cancelToken {
    return ApiService.cancelToken;
  }

  CancelToken get topsearchCancelToken {
    return ApiService.topsearchCancelToken;
  }

  Rx<MainPageModel> homePageList = MainPageModel().obs;
  Rx<SingleAlbumModel> albumList = SingleAlbumModel().obs;
  Rx<PlaylistModel> playListList = PlaylistModel().obs;
  Rx<Song> singleSong = Song().obs;
  Rx<TopSearchModel> topSearch = TopSearchModel().obs;
  Rx<ViewAllSongsModel> detailSearch = ViewAllSongsModel().obs;

  void fetchSearchDetail(
      String value, int page, ViewFuctionType querytype) async {
    if (page == 1) detailSearch(ViewAllSongsModel());
    if (detailSearch.value.total == 0) isloading(true);
    try {
      var _viewAllSongsData =
          await ApiService.fetchViewAllSongs(value, page, querytype);

      if (_viewAllSongsData != null) {
        if (page == 1) {
          detailSearch(_viewAllSongsData);
        } else if (page > 1 && _viewAllSongsData.results.isNotEmpty) {
          detailSearch.update((val) {
            val!.results.addAll(_viewAllSongsData.results);
          });
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isloading(false);
    }
  }

  void fetchTopsearch(String value) async {
    var _topSearchPageData = await ApiService.fetchTopSearch(value);
    if (_topSearchPageData != null) {
      topSearch(_topSearchPageData);
    }
  }

  void fetchHomePage() async {
    var _homepagedata = await ApiService.fetchHomePage();
    if (_homepagedata != null) {
      homePageList(_homepagedata);
    }
  }

  void fetchAlbum(String id) async {
    isloading(true);
    albumList(SingleAlbumModel());
    try {
      var _albumlist = await ApiService.fetchAlbum(id);
      if (_albumlist != null) {
        albumList(_albumlist);
      }
    } finally {
      isloading(false);
    }
  }

  void fetchPlaylist(String id) async {
    isloading(true);
    playListList(PlaylistModel());
    try {
      var _playList = await ApiService.fetchPlaylist(id);
      if (_playList != null) {
        playListList(_playList);
      }
    } finally {
      isloading(false);
    }
  }

  Future<void> fetchSong(String id) async {
    try {
      Song? _singlesong = await ApiService.fetchSong(id);
      if (_singlesong != null) {
        singleSong(_singlesong);
      }
    } catch (e) {}
  }
}
