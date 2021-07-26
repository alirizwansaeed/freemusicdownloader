import 'dart:io';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:filesize/filesize.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadController extends GetxController {
  Dio _dio = Dio();
  CancelToken _downlaodcancelToken = CancelToken();
  CancelToken _songSizeCancelToken = CancelToken();
  var kbps96 = '...'.obs;
  var kbps160 = '...'.obs;
  var kbps320 = '...'.obs;
  var progress = 0.0.obs;

  Future<void> downloadSong({
    required String? url,
    required String? quality,
    required String? name,
  }) async {
    progress(0.0);
    if (await _permissionmanager()) {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_MUSIC);
      Directory directory = Directory(path + '/Floovi Music');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File _file = File(directory.path + '/$name' + '$quality' + '.mp3');
        if (await _file.exists()) {
          progress(1.0);
          return;
        } else
          try {
            _downlaodcancelToken = CancelToken();
            await _dio.download(
              url!,
              _file.path,
              cancelToken: _downlaodcancelToken,
              onReceiveProgress: (downloaded, totalsize) {
                progress(downloaded / totalsize);
              },
            );
          } on DioError catch (e) {
            print(e.error);
          }
      }
    }
  }

  Future<void> songSize(String value, String is320) async {
    _resetsongsize();
    _songSizeCancelToken = CancelToken();
    try {
      var responce96 =
          await _dio.head(value, cancelToken: _songSizeCancelToken);
      kbps96(filesize(responce96.headers['content-length']![0]));
    } on DioError catch (e) {
      kbps96('N/A');
      print(e.error);
    }
    try {
      var responce160 = await _dio.head(value.replaceAll('_96.mp4', '_160.mp4'),
          cancelToken: _songSizeCancelToken);
      kbps160(filesize(responce160.headers['content-length']![0]));
    } on DioError catch (e) {
      kbps160('N/A');
      print(e.error);
    }

    try {
      if (is320 == 'true') {
        var responce320 = await _dio.head(
            value.replaceAll('_96.mp4', '_320.mp4'),
            cancelToken: _songSizeCancelToken);
        kbps320(filesize(responce320.headers['content-length']![0]));
      }
    } on DioError catch (e) {
      kbps160('N/A');
      print(e.error);
    }
  }

  void _resetsongsize() {
    progress(0.0);
    kbps160('...');
    kbps320('...');
    kbps96('...');
  }

  void downloadCancelToken() {
    if (_downlaodcancelToken.isCancelled) {
      return;
    } else {
      _downlaodcancelToken.cancel('download cancel by user');
    }
  }

  void songSizeCancelToken() {
    if (_songSizeCancelToken.isCancelled) {
      return;
    } else {
      _songSizeCancelToken.cancel('size cancel by user');
    }
  }

  Future<bool> _permissionmanager() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    } else {
      var result = await Permission.storage.request();
      if (result.isGranted) {
        return true;
      } else
        return false;
    }
  }
}
