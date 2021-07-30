import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

import 'package:freemusicdownloader/Models/SingleSong.dart';

class AudioPlayerService {
  AudioPlayer _audioPlayer = AudioPlayer();

  AudioSource? get audioSource {
    return _audioPlayer.audioSource;
  }

  Stream<PositionData> get positiondataStream {
    return CombineLatestStream.combine7<LoopMode, bool, Duration, Duration,
        Duration?, int?, PlayerState, PositionData>(
      _audioPlayer.loopModeStream,
      _audioPlayer.shuffleModeEnabledStream,
      _audioPlayer.positionStream,
      _audioPlayer.bufferedPositionStream,
      _audioPlayer.durationStream,
      _audioPlayer.currentIndexStream,
      _audioPlayer.playerStateStream,
      (loopmode, shuffle, position, bufferPosition, duration, index,
              processingstate) =>
          PositionData(
        bufferedPosition: bufferPosition,
        duration: duration,
        position: position,
        index: index!,
        playerState: processingstate,
        loopMode: loopmode,
        shuffle: shuffle,
      ),
    );
  }

  Future<void> loadSongs(List<Song> songs, int index) async {
    await _audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          children: songs
              .map(
                (e) => AudioSource.uri(
                  Uri.parse(
                    e.encryptedMediaUrl,
                  ),
                  tag: MediaItem(
                    id: e.id,
                    title: e.song,
                    artUri: Uri.parse(e.image),
                    artist: e.primaryartists,
                  ),
                ),
              )
              .toList(),
        ),
        initialIndex: index);
    _audioPlayer.play();
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void previous() {
    _audioPlayer.seekToPrevious();
  }

  void next() {
    _audioPlayer.seekToNext();
  }

  void seekTo(double position, {int? index}) {
    _audioPlayer.seek(Duration(milliseconds: position.toInt()), index: index);
  }

 Future< void> loopMood(LoopMode loopMode)async {
   await _audioPlayer.setLoopMode(loopMode);
  }

  Future<void> shuffle(bool shaffle) async {
    await _audioPlayer.setShuffleModeEnabled(shaffle);
  await  _audioPlayer.shuffle();
  }
}

class PositionData {
  final Duration? position;
  final Duration? bufferedPosition;
  final Duration? duration;
  final int? index;
  final PlayerState? playerState;
  final bool? shuffle;
  final LoopMode loopMode;

  PositionData({
    required this.position,
    required this.bufferedPosition,
    required this.duration,
    required this.index,
    required this.playerState,
    this.shuffle,
    required this.loopMode,
  });
}
