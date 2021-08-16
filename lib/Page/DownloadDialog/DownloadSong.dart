import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freemusicdownloader/Controller/DownloadController.dart';

class DownloadSong extends StatelessWidget {
  final String songName;
  final String songUrl;
  final String is320;
  DownloadSong({
    Key? key,
    required this.songName,
    required this.songUrl,
    required this.is320,
  }) : super(key: key);
  final _downloadController = Get.find<DownloadController>();

  @override
  Widget build(BuildContext context) {
    _downloadController.songSize(songUrl, is320);

    return WillPopScope(
      onWillPop: () async {
        _downloadController.songSizeCancelToken();
        return true;
      },
      child: Container(
        height: 120,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: _innerWidget(),
      ),
    );
  }

  Widget _innerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          songName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Color(0xFF333b66),
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Wrap(
          children: [
            Bounce(
              duration: Duration(milliseconds: 200),
              onPressed: () async {
                Get.back();

                Get.showSnackbar(GetBar(
                    message: 'Downloading Start',
                    duration: Duration(seconds: 2)));
                _downloadController.downloadSong(
                    url: songUrl, name: songName, quality: '96kbps');
              },
              child: Card(
                child: SizedBox(
                  height: 60,
                  width: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '96 Kbps',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333b66),
                            fontSize: 14),
                      ),
                      Obx(
                        () => Text(
                          '${_downloadController.kbps96}',
                          style: GoogleFonts.nunito(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Bounce(
              duration: Duration(milliseconds: 200),
              onPressed: () {
                Get.back();
                Get.showSnackbar(GetBar(
                  message: 'Downloading Start',
                  duration: Duration(seconds: 2),
                ));
                _downloadController.downloadSong(
                    url: songUrl.replaceAll('_96.mp4', '_160.mp4'),
                    name: songName,
                    quality: '160kbps');
              },
              child: Card(
                child: SizedBox(
                  height: 60,
                  width: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '160 Kbps',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333b66),
                            fontSize: 14),
                      ),
                      Obx(
                        () => Text(
                          '${_downloadController.kbps160}',
                          style: GoogleFonts.nunito(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Bounce(
              duration: Duration(milliseconds: 200),
              onPressed: () {
                Get.back();
                Get.showSnackbar(GetBar(
                  message: 'Downloading Start',
                  duration: Duration(seconds: 2),
                ));
                _downloadController.downloadSong(
                    url: songUrl.replaceAll('_96.mp4', '_320.mp4'),
                    name: songName,
                    quality: '320kbps');
              },
              child: Card(
                child: SizedBox(
                  height: 60,
                  width: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '320Kbps',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333b66),
                            fontSize: 14),
                      ),
                      Obx(
                        () => Text(
                          '${_downloadController.kbps320}',
                          style: GoogleFonts.nunito(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
