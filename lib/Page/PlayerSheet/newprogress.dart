import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:freemusicdownloader/Controller/AudioPlayerController.dart';
import 'package:freemusicdownloader/Services/AudioPlayerService.dart';
import 'package:get/get.dart';

class Newprogress extends StatelessWidget {
  Newprogress({Key? key}) : super(key: key);
  final _audioController = Get.find<AudioPlayerController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PositionData>(
        stream: _audioController.positiondataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ProgressBar(
                thumbGlowColor: Color(0xFF2BC5B4).withOpacity(.3),
                thumbRadius: 6,
                thumbColor: Color(0xFF2BC5B4),
                progressBarColor: Color(0xFF2BC5B4),
                bufferedBarColor: Colors.grey.shade400,
                baseBarColor: Colors.grey.shade400.withOpacity(.5),
                thumbGlowRadius: 20.0,
                thumbCanPaintOutsideBar: false,
                barHeight: 4,
                buffered: snapshot.data!.bufferedPosition ?? Duration.zero,
                progress: snapshot.data!.position ?? Duration.zero,
                total: snapshot.data!.duration ?? Duration.zero,
                onSeek: (value) => _audioController.seekto(value),
                timeLabelTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            );
          } else
            return SizedBox.shrink();
        });
  }
}
