import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:freemusicdownloader/Models/SingleSong.dart';
import 'package:freemusicdownloader/Services/AudioService.dart';
import 'package:freemusicdownloader/Shared/FormatedString.dart';
import 'package:freemusicdownloader/Shared/ImageQuality.dart';
import 'package:get/get.dart';

class AudioController extends GetxController {
  var _isStatenone = true.obs;
  var _isrunning = false.obs;
  var isPlaying = false.obs;
  var _bufferPosition = 0.0.obs;
  var currentAlbumid = ''.obs;
  var _currentPosition = 0.0.obs;
  var _isConcatingState = false.obs;

  bool get isNoneState {
    return _isStatenone.value;
  }

  bool get isLoadingState {
    return _isrunning.value && _isStatenone.value && _isConcatingState.value;
  }

  double get currentPosition {
    return _currentPosition.value >
            currentMediaItem.value.duration!.inMilliseconds
        ? currentMediaItem.value.duration!.inMilliseconds.toDouble()
        : _currentPosition.value;
  }

  double get bufferPosition {
    return _bufferPosition.value >
            currentMediaItem.value.duration!.inMilliseconds
        ? currentMediaItem.value.duration!.inMilliseconds.toDouble()
        : _bufferPosition.value;
  }

  Rx<MediaItem> currentMediaItem = MediaItem(
    id: '',
    album: '',
    title: '',
  ).obs;
  @override
  void onInit() {
    AudioService.playbackStateStream
        .listen((event) => _playbackStateStream(event));
    AudioService.currentMediaItemStream
        .listen((event) => _currentMediaItem(mediaItem: event));
    AudioService.positionStream.listen((event) {
      _currentPosition(event.inMilliseconds.toDouble());
    });
    AudioService.runningStream.listen((event) {
      _isrunning(event);
    });

    super.onInit();
  }

  void _currentMediaItem(
      {MediaItem? mediaItem = const MediaItem(id: '', album: '', title: '')}) {
    if (_bufferPosition > mediaItem!.duration!.inMilliseconds.toDouble()) {
      _bufferPosition(mediaItem.duration!.inMilliseconds.toDouble());
    }

    currentAlbumid(mediaItem.extras!['albumid']);
    currentMediaItem(mediaItem);
  }

  void _playbackStateStream(PlaybackState _playbackState) {
    if (_playbackState.playing) {
      _isStatenone(false);
      _isConcatingState(false);
    }

    if (_playbackState.processingState == AudioProcessingState.none) {
      _isStatenone(true);
    }
    if (_playbackState.processingState == AudioProcessingState.connecting) {
      _isConcatingState(true);
    }

    _bufferPosition(
      _playbackState.bufferedPosition.inMilliseconds.toDouble(),
    );

    isPlaying(_playbackState.playing);
  }

  Future<void> play(
      {required List<Song>? songs,
      required int? index,
      required String albumid}) async {
    if (!AudioService.running) {
      await AudioService.start(backgroundTaskEntrypoint: entrypoint);
    }
    await AudioService.updateQueue(
      songs!
          .map(
            (e) => MediaItem(
              extras: {
                'albumid': albumid,
                'imageUrl': "${e.image}",
                'year': e.year
              },
              id: '${e.encryptedMediaUrl}',
              album: e.album,
              title: e.song,
              artUri: Uri.parse(
                ImageQuality.imageQuality(value: e.image, size: 50),
              ),
              artist: FormatedString.formatedString(
                  e.singers == '' ? e.primaryartists : e.singers),
            ),
          )
          .toList(),
    );
    await AudioService.skipToQueueItem(index.toString());
    await AudioService.play();
  }

  Future<void> seekto(double value) async {
    await AudioService.seekTo(Duration(milliseconds: value.toInt()));
  }

  Future<void> playPause() async {
    return isPlaying.value
        ? await AudioService.pause()
        : await AudioService.play();
  }

  Future<void> skipToNext() async {
    AudioService.skipToNext();
  }

  Future<void> skipToBack() async {
    AudioService.skipToPrevious();
  }
}
