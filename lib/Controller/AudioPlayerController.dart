import 'package:flutter/material.dart';
import 'package:freemusicdownloader/Controller/ApiController.dart';
import 'package:freemusicdownloader/Models/SingleSong.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

class AudioplayerController extends GetxController {
  final ApiController _apicontroller = Get.find<ApiController>();
  final _player = AudioPlayer();
  Rx<double> songcurrentPosition = 0.0.obs;
  Rx<double> songDuration = 1.0.obs;
  Rx<double> bufferedposition = 0.0.obs;
  Rx<bool> isplaying = false.obs;
  Rx<bool> isPlayerinitilized = false.obs;
  Rx<Song> songProperties = Song().obs;

  @override
  void onInit() {
    super.onInit();

    _playerstates();
  }

  Future<void> playPauseButton() async {
    isplaying.value ? _player.pause() : _player.play();
  }

  Future<void> seekButton(double value) async {
    songcurrentPosition(
      value,
    );
    _player.seek(
      Duration(
        milliseconds: value.toInt(),
      ),
    );
  }

  Future<void> stopButton() async {
    _player.stop();
  }

  Future<void> nextSongButton() async {
    if (_player.hasNext) {
      await _player.seekToNext();
      return;
    } else {
      Get.snackbar(
        '',
        '',
        messageText: Center(
            child: Text('No More Track Avaliable',
                style: GoogleFonts.numans(fontWeight: FontWeight.bold))),
        titleText: Center(
            child: Text(
          '💓💓💓💓',
          style: TextStyle(fontSize: 20),
        )),
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.TOP,
      );
    }
    return;
  }

  Future<void> previousButtonSong() async {
    if (_player.hasPrevious) {
      await _player.seekToPrevious();

      return;
    } else {
      Get.snackbar(
        '',
        '',
        isDismissible: false,
        messageText: Center(
            child: Text('No More Track Avaliable',
                style: GoogleFonts.numans(fontWeight: FontWeight.bold))),
        titleText: Center(
            child: Text(
          '💓💓💓💓',
          style: TextStyle(fontSize: 30),
        )),
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
  }

  Future<void> loadalbum(int index) async {
    _player.stop();

    await _player.setAudioSource(
      ConcatenatingAudioSource(
        children: _apicontroller.albumList.value.songs
            .map(
              (e) => AudioSource.uri(
                Uri.parse(
                  e.encryptedMediaUrl,
                ),
              ),
            )
            .toList(),
      ),
      initialIndex: index,
    );
    isPlayerinitilized(true);
    _albumCurrentIndex();
    await _player.play();
  }

  Future<void> loadPlaylist(int index) async {
    _player.stop();

    await _player.setAudioSource(
      ConcatenatingAudioSource(
        children: _apicontroller.playListList.value.songs
            .map(
              (e) => AudioSource.uri(
                Uri.parse(
                  e.encryptedMediaUrl,
                ),
              ),
            )
            .toList(),
      ),
      initialIndex: index,
    );
    isPlayerinitilized(true);
    _playListCurrentIndex();
    await _player.play();
  }

  void _playerstates() {
    _player.bufferedPositionStream.listen((event) {
      bufferedposition(event.inMilliseconds.toDouble()).obs;
    });
    _player.durationStream.listen((event) {
      songDuration(event!.inMilliseconds.toDouble()).obs;
    });
    _player.positionStream.listen((event) {
      songcurrentPosition(event.inMilliseconds.toDouble()).obs;
    });

    _player.playerStateStream.listen(
      (state) {
        isplaying(state.playing).obs;
        print(state.processingState);

        if (state.processingState == ProcessingState.completed) {
          if (!_player.hasNext) {
            _player.seek(Duration(seconds: 0));
            _player.pause();
          }
          if (_player.hasNext) {
            _player.seekToNext();
          }
        }
      },
    );
  }

  Future<void> _albumCurrentIndex() async {
    _player.currentIndexStream.listen((index) {
      songProperties(_apicontroller.albumList.value.songs[index!]);
    });
  }

  Future<void> _playListCurrentIndex() async {
    _player.playbackEventStream.listen((event) {
      print(event);
    });

    _player.currentIndexStream.listen((index) {
      songProperties(_apicontroller.playListList.value.songs[index!]);
    });
  }

  Future<void> _singlesong() async {
    songProperties(_apicontroller.singlesong.value);
  }

  Future<void> loadsong() async {
    _player.stop();

    await _player.setUrl(_apicontroller.singlesong.value.encryptedMediaUrl);
    isPlayerinitilized(true);
    _singlesong();
    await _player.play();
  }
}
