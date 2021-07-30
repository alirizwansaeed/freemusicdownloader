import 'package:flutter/foundation.dart';
import 'package:freemusicdownloader/Services/AudioPlayerService.dart';
import 'package:freemusicdownloader/Models/SingleSong.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerController extends GetxController {
  AudioPlayerService _audioService = AudioPlayerService();
  var _isplaying = false.obs;
  var _position = Duration(microseconds: 1).obs;
  var _duration = Duration(milliseconds: 1).obs;
  var _bufferPosition = Duration.zero.obs;
  var _processingState = ProcessingState.idle.obs;
  var _currentPlayingIndex = 0.obs;
  var _currentalbumid = ''.obs;
  var _ishuffle = false.obs;
  Rx<LoopMode> _loopMode = LoopMode.off.obs;
  RxList<Song> _currentlyPlayingSongs = <Song>[].obs;

  LoopMode get loopmode {
    return _loopMode.value;
  }

  String get currentAlbumId {
    return _isplaying.value ? _currentalbumid.value : '';
  }

  Song get currentPlayingSong {
    return _currentlyPlayingSongs.isEmpty
        ? Song()
        : Song(
            id: _currentlyPlayingSongs[_currentPlayingIndex.value].id,
            album: _currentlyPlayingSongs[_currentPlayingIndex.value].album,
            image: _currentlyPlayingSongs[_currentPlayingIndex.value].image,
            singers:
                _currentlyPlayingSongs[_currentPlayingIndex.value].singers == ''
                    ? _currentlyPlayingSongs[_currentPlayingIndex.value]
                        .primaryartists
                    : _currentlyPlayingSongs[_currentPlayingIndex.value]
                        .singers,
            song: _currentlyPlayingSongs[_currentPlayingIndex.value].song,
            year: _currentlyPlayingSongs[_currentPlayingIndex.value].year,
            the320Kbps:
                _currentlyPlayingSongs[_currentPlayingIndex.value].the320Kbps,
            encryptedMediaUrl:
                _currentlyPlayingSongs[_currentPlayingIndex.value]
                    .encryptedMediaUrl,
          );
  }

  bool get isplaying {
    return _isplaying.value;
  }

  Duration get position {
    return _position.value > _duration.value
        ? _duration.value
        : _position.value;
  }

  Duration get duration {
    return _duration.value;
  }

  Duration get bufferPostion {
    return _bufferPosition.value > _duration.value
        ? _duration.value
        : _bufferPosition.value;
  }

  ProcessingState get playerProcessingState {
    return _processingState.value;
  }

  bool get isshuffle {
    return _ishuffle.value;
  }

  @override
  void onInit() {
    _audioService.positiondataStream.listen((event) {
      _loopMode(event.loopMode);
      _ishuffle(event.shuffle);
      _isplaying(event.playerState!.playing);
      _currentPlayingIndex(event.index);
      _position(event.position == null ? Duration.zero : event.position);
      _duration(event.duration == null ? Duration.zero : event.duration);
      _bufferPosition(
        event.bufferedPosition == null ? Duration.zero : event.bufferedPosition,
      );
      _processingState(event.playerState!.processingState);
    });
    super.onInit();
  }

  void loadSong(List<Song> songs, int index, String currentalbumid) async {
    if (listEquals(_currentlyPlayingSongs, songs)) {
      _audioService.seekTo(0.0, index: index);
      _audioService.play();
    } else
      _currentlyPlayingSongs.clear();
    _currentlyPlayingSongs(songs);
    await _audioService.loadSongs(songs, index);
    _currentalbumid(currentalbumid);
  }

  void next() {
    _audioService.next();
  }

  void playpause() {
    isplaying ? _audioService.pause() : _audioService.play();
  }

  void previous() {
    _audioService.previous();
  }

  void seekto(double duration, {int? index}) {
    _audioService.seekTo(duration);
  }

  Future<void> shaffle() async {
    isshuffle
        ? await _audioService.shuffle(false)
        : await _audioService.shuffle(true);
  }

  Future<void> loop() async {
    print(loopmode);
    if (loopmode == LoopMode.off) {
      await _audioService.loopMood(LoopMode.one);
    } else if (loopmode == LoopMode.one) {
      await _audioService.loopMood(LoopMode.all);
    } else if (loopmode == LoopMode.all) {
      await _audioService.loopMood(LoopMode.off);
    }
  }
}
