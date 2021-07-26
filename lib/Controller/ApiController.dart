import 'package:freemusicdownloader/Models/MainPageModel.dart';
import 'package:freemusicdownloader/Models/PlaylistModel.dart';
import 'package:freemusicdownloader/Models/AlbumModel.dart';
import 'package:freemusicdownloader/Models/SingleSong.dart';
import 'package:freemusicdownloader/Services/ApiService.dart';
import 'package:get/get.dart';

class ApiController extends GetxController {
  var isAlbumLoading = false.obs;
  var isPlaylistLoading = false.obs;
  Rx<MainPageModel> homePageList = MainPageModel().obs;
  Rx<SingleAlbumModel> albumList = SingleAlbumModel().obs;
  Rx<PlaylistModel> playListList = PlaylistModel().obs;
  Rx<Song> singlesong = Song().obs;

  void fetchHomePage() async {
    var _homepagedata = await ApiService.fetchHomePage();
    if (_homepagedata != null) {
      homePageList(_homepagedata);
    }
  }

  void fetchAlbum(String id) async {
    isAlbumLoading(true);
    try {
      var _albumlist = await ApiService.fetchAlbum(id);

      if (_albumlist != null) {
        albumList(_albumlist);
      }
    } finally {
      isAlbumLoading(false);
    }
  }

  void fetchPlaylist(String id) async {
    isPlaylistLoading(true);
    try {
      var _playList = await ApiService.fetchPlaylist(id);
      if (_playList != null) {
        playListList(_playList);
      }
    } finally {
      isPlaylistLoading(false);
    }
  }

  Future<void> fetchSong(String id) async {
    try {
      Song? _singlesong = await ApiService.fetchSong(id);
      if (_singlesong != null) {
        singlesong(_singlesong);
      }
    } catch (e) {}
  }
}
