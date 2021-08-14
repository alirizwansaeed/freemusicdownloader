import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:freemusicdownloader/Models/MainPageModel.dart';
import 'package:freemusicdownloader/Models/PlaylistModel.dart';
import 'package:freemusicdownloader/Models/AlbumModel.dart';
import 'package:freemusicdownloader/Models/Search/TopSearchModel.dart';
import 'package:freemusicdownloader/Models/Search/ViewAllSongs.dart';
import 'package:freemusicdownloader/Models/SingleSong.dart';
import 'package:freemusicdownloader/Page/SearchBar/SearchBar.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ApiService extends GetxController {
  static Dio _dio = Dio();
  static CancelToken cancelToken = CancelToken();
  static CancelToken topsearchCancelToken = CancelToken();

  static Future<ViewAllSongsModel?> fetchViewAllSongs(
      String query, int page, ViewFuctionType quarytype) async {
    cancelToken = CancelToken();
    try {
      var _responce = await _dio.get(
        quarytype == ViewFuctionType.SONG
            ? 'https://www.jiosaavn.com/api.php?p=$page&q=$query&_format=json&_marker=0&api_version=4&ctx=wap6dot0&n=20&__call=search.getResults'
            : quarytype == ViewFuctionType.PLAYLIST
                ? 'https://www.jiosaavn.com/api.php?p=$page&q=$query&_format=json&_marker=0&api_version=4&ctx=wap6dot0&n=20&__call=search.getPlaylistResults'
                : 'https://www.jiosaavn.com/api.php?p=$page&q=$query&_format=json&_marker=0&api_version=4&ctx=wap6dot0&n=20&__call=search.getAlbumResults',
        cancelToken: cancelToken,
      );
      if (_responce.statusCode == 200) {
        return viewAllSongsModelFromJson(_responce.data);
      }
    } on DioError catch (e) {
      print(e.error);
    }
  }

  static Future<TopSearchModel?> fetchTopSearch(String query) async {
    if (!topsearchCancelToken.isCancelled) {
      topsearchCancelToken.cancel('Cancel search by user');
      topsearchCancelToken = CancelToken();
    }
    try {
      var _responce = await _dio.get(
        'https://www.jiosaavn.com/api.php?__call=autocomplete.get&query=$query&_format=json&_marker=0&ctx=wap6dot0',
        cancelToken: topsearchCancelToken,
      );
      if (_responce.statusCode == 200) {
        return topSearchModelFromJson(_responce.data);
      }
    } on DioError catch (e) {
      print(e.error);
    }
  }

  static Future<MainPageModel?> fetchHomePage() async {
    var _responce = await _dio.get(
        'https://www.jiosaavn.com/api.php?__call=webapi.getLaunchData&api_version=4&_format=json&_marker=0');
    if (_responce.statusCode == 200) {
      return mainPageModelFromJson(_responce.data);
    }
  }

  static Future<SingleAlbumModel?> fetchAlbum(String id) async {
    cancelToken = CancelToken();
    try {
      var _responce = await _dio.get(
          'https://www.jiosaavn.com/api.php?__call=content.getAlbumDetails&_format=json&cc=in&_marker=0%3F_marker%3D0&albumid=$id',
          cancelToken: cancelToken);

      if (_responce.statusCode == 200) {
        return singleAlbumFromJson(_responce.data);
      }
    } on DioError catch (e) {
      print(e.error);
    }
  }

  static Future<PlaylistModel?> fetchPlaylist(String id) async {
    cancelToken = CancelToken();
    try {
      var _responce = await _dio.get(
          'https://www.jiosaavn.com/api.php?__call=playlist.getDetails&_format=json&cc=in&_marker=0%3F_marker%3D0&listid=$id',
          cancelToken: cancelToken);
      if (_responce.statusCode == 200) {
        return playlistFromJson(_responce.data);
      }
    } on DioError catch (e) {
      print(e.error);
    }
  }

  static Future<Song?> fetchSong(String id) async {
    try {
      var _responce = await _dio.get(
        'https://www.jiosaavn.com/api.php?__call=song.getDetails&cc=in&_marker=0%3F_marker%3D0&_format=json&pids=$id',
      );
      var test = jsonDecode(_responce.data);
      if (_responce.statusCode == 200) {
        return songFromJson(jsonEncode(test[id]));
      }
    } on DioError catch (e) {
      print(e.error);
    }
  }
}
