import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

void entrypoint() => AudioServiceBackground.run(() => AudioPlayerTask());

class AudioPlayerTask extends BackgroundAudioTask {
  final _player = AudioPlayer();
  var _queue = <MediaItem>[];

  List<MediaItem> get queue => _queue;
  Duration? _duration = Duration.zero;
  Duration get duration => _duration ?? Duration.zero;
  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    _player.bufferedPositionStream.listen((event) {
      AudioServiceBackground.setState(bufferedPosition: event);
    });
    _player.positionStream.listen(
      (event) {
        AudioServiceBackground.setState(position: event);
      },
    );
    _player.playerStateStream.listen(
      (playerState) {
        AudioServiceBackground.setState(
          systemActions: [
            MediaAction.seekTo,
            MediaAction.seekForward,
            MediaAction.playPause,
            MediaAction.skipToPrevious,
            MediaAction.skipToPrevious
          ],
          playing: playerState.playing,
          processingState: {
            ProcessingState.idle: AudioProcessingState.none,
            ProcessingState.loading: AudioProcessingState.connecting,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[playerState.processingState],
          controls: [
            MediaControl.skipToPrevious,
            playerState.playing ? MediaControl.pause : MediaControl.play,
            MediaControl.skipToNext,
            MediaControl.stop,
          ],
        );
      },
    );

    _player.durationStream.listen(
      (durationstream) {
        _player.currentIndexStream.listen(
          (event) {
            AudioServiceBackground.setMediaItem(MediaItem(
              id: '${queue[event ?? 0].id}',
              album: queue[event ?? 0].album,
              title: queue[event ?? 0].title,
              artUri: queue[event ?? 0].artUri,
              artist: queue[event ?? 0].artist,
              duration: durationstream,
              extras: queue[event ?? 0].extras,
            ));
          },
        );
      },
    );
    return super.onStart(params);
  }

  @override
  Future<void> onClose() {
    _player.stop();
    return super.onClose();
  }

  @override
  Future<void> onPause() {
    _player.pause();
    return super.onPause();
  }

  @override
  Future<void> onPlay() {
    _player.play();
    return super.onPlay();
  }

  @override
  Future<void> onSeekTo(Duration position) {
    _player.seek(position);
    return super.onSeekTo(position);
  }

  @override
  Future<void> onStop() {
    _player.stop();
    return super.onStop();
  }

  @override
  Future<void> onSkipToNext() {
    _player.seekToNext();

    return super.onSkipToNext();
  }

  @override
  Future<void> onSkipToPrevious() {
    _player.seekToPrevious();
    return super.onSkipToPrevious();
  }

  @override
  Future<void> onUpdateQueue(List<MediaItem> queue) async {
    if (listEquals(_queue, queue)) {
      return super.onUpdateQueue(queue);
    } else
      _queue.clear();
    await AudioServiceBackground.setQueue(_queue = queue);
    await _player.setAudioSource(
        ConcatenatingAudioSource(
          children:
              queue.map((e) => AudioSource.uri(Uri.parse('${e.id}'))).toList(),
        ),
        initialIndex: 0);

    return super.onUpdateQueue(queue);
  }

  @override
  Future<void> onSkipToQueueItem(String mediaId) async {
    _player.seek(Duration.zero, index: int.parse(mediaId));
    return super.onSkipToQueueItem(mediaId);
  }
}
