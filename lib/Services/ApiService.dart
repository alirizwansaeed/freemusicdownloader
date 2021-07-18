import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:freemusicdownloader/Models/MainPageModel.dart';
import 'package:freemusicdownloader/Models/PlaylistModel.dart';
import 'package:freemusicdownloader/Models/AlbumModel.dart';
import 'package:freemusicdownloader/Models/SingleSong.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ApiService extends GetxController {
  static Dio _dio = Dio();

  static Future<MainPageModel?> fetchHomePage() async {
    var _responce = await _dio.get(
        'https://www.jiosaavn.com/api.php?__call=webapi.getLaunchData&api_version=4&_format=json&_marker=0');
    if (_responce.statusCode == 200) {
      return mainPageModelFromJson(_responce.data);
    } else
      return null;
  }

  static Future<SingleAlbumModel?> fetchAlbum(String id) async {
    var _responce = await _dio.get(
      'https://www.jiosaavn.com/api.php?__call=content.getAlbumDetails&_format=json&cc=in&_marker=0%3F_marker%3D0&albumid=$id',
    );

    if (_responce.statusCode == 200) {
      return singleAlbumFromJson(_responce.data);
    } else
      return null;
  }

  static Future<PlaylistModel?> fetchPlaylist(String id) async {
    var _responce = await _dio.get(
      'https://www.jiosaavn.com/api.php?__call=playlist.getDetails&_format=json&cc=in&_marker=0%3F_marker%3D0&listid=$id',
    );
    if (_responce.statusCode == 200) {
      return playlistFromJson(_responce.data);
    } else
      return null;
  }

  static Future<Song?> fetchSong(String id) async {
    var _responce = await _dio.get(
      'https://www.jiosaavn.com/api.php?__call=song.getDetails&cc=in&_marker=0%3F_marker%3D0&_format=json&pids=$id',
    );
    var test = jsonDecode(_responce.data);
    var endode = jsonEncode(test[id]);
    if (_responce.statusCode == 200) {
      return songFromJson(endode);
    } else
      return null;
  }
}
