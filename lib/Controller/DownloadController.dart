import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:filesize/filesize.dart';
import 'package:flowder/flowder.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadController extends GetxController {
  ReceivePort _port = ReceivePort();
  Dio _dio = Dio();
  CancelToken _downlaodcancelToken = CancelToken();
  CancelToken _songSizeCancelToken = CancelToken();
  late DownloaderCore core;
  var kbps96 = '...'.obs;
  var kbps160 = '...'.obs;
  var kbps320 = '...'.obs;
  var progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    FlutterDownloader.registerCallback(downloadCallback);

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
  }

  @override
  void onClose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.onClose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int downloadprogress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, downloadprogress]);
  }

  void createPath() async {
    if (await _permissionmanager()) {
      var path = await ExternalPath.getExternalStorageDirectories();
      Directory directory = Directory(path[0] + '/Floovi');
      await directory.create();
      print(path[0]);
    }
  }

  Future<void> downloadSong({
    required String? url,
    required String? quality,
    required String? name,
  }) async {
    progress(0.0);
    if (await _permissionmanager()) {
      var path = await ExternalPath.getExternalStorageDirectories();
      Directory directory = Directory(path[0] + '/Floovi');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File _file = File(directory.path + '/$name' + '$quality' + '.mp3');
        if (await _file.exists()) {
          _file.delete();
        }
        try {
          await FlutterDownloader.enqueue(
            url: url!,
            fileName: '$name' + '$quality' + '.mp3',
            savedDir: directory.path,
            showNotification: true,
            openFileFromNotification: true,
          );
        } catch (e) {
          print(e);

          // try {
          //   await FlutterDownloader.enqueue(
          //     url: url!,
          //     fileName: '$name' + '$quality' + '.mp3',
          //     savedDir: directory.path,
          //     showNotification: true,
          //     openFileFromNotification: true,
          //   );

          // final downloaderUtils = DownloaderUtils(
          //   progressCallback: (current, total) {
          //     progress((current / total));
          //   },
          //   file: _file,
          //   progress: ProgressImplementation(),
          //   onDone: () => print('Download done'),
          //   deleteOnCancel: true,
          // );
          //   core = await Flowder.download(url!, downloaderUtils);
          // } catch (e) {
          //   print(e);
          // }
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
