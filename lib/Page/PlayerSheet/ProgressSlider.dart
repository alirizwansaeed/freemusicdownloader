import 'package:another_xlider/another_xlider.dart';
import 'package:flutter/material.dart';

import 'package:freemusicdownloader/Controller/AudioPlayerController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressSlider extends StatelessWidget {
  ProgressSlider({Key? key}) : super(key: key);
  final Rx<bool> _isSliderTapped = false.obs;
  final AudioplayerController _audioplayerService =
      Get.find<AudioplayerController>();
  final Rx<double> slidervalue = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          SizedBox(
            height: 25,
            child: Stack(
              children: [
                AbsorbPointer(
                  absorbing: true,
                  child: SliderTheme(
                    data: SliderThemeData(
                      disabledActiveTrackColor: Colors.grey,
                      disabledThumbColor: Colors.grey,
                      trackHeight: _isSliderTapped.value ? 13 : 3,
                      disabledInactiveTrackColor: Colors.transparent,
                      thumbShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(
                      value: _audioplayerService.bufferedposition.value,
                      min: 0,
                      max: _audioplayerService.songDuration.value,
                      onChanged: null,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 13,
                    left: 14,
                  ),
                  child: FlutterSlider(
                    values: [
                      _audioplayerService.songcurrentPosition.value,
                    ],
                    max: _audioplayerService.songDuration.value,
                    min: 0,
                    handlerHeight: 20,
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      slidervalue(lowerValue);
                    },
                    onDragCompleted:
                        (handlerIndex, lowerValue, upperValue) async {
                      _isSliderTapped(false);
                      await _audioplayerService.seekButton(slidervalue.value);
                    },
                    onDragStarted: (handlerIndex, lowerValue, upperValue) =>
                        _isSliderTapped(true),
                    trackBar: FlutterSliderTrackBar(
                      activeTrackBarHeight: _isSliderTapped.value ? 16 : 6,
                      inactiveTrackBarHeight: _isSliderTapped.value ? 14 : 4,
                      inactiveTrackBar: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300,
                      ),
                      activeTrackBar: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [Colors.amber, Colors.pink],
                        ),
                      ),
                    ),
                    handler: FlutterSliderHandler(
                      opacity: _isSliderTapped.value ? 0 : 1,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.pink,
                        ),
                      ),
                    ),
                    tooltip: FlutterSliderTooltip(
                      format: (value) {
                        return '${Duration(milliseconds: slidervalue.value.toInt()).inMinutes}:${Duration(milliseconds: slidervalue.value.toInt()).inSeconds.remainder(60).toString().padLeft(2, '0')}';
                      },
                      textStyle: GoogleFonts.nunito(color: Colors.white),
                      boxStyle: FlutterSliderTooltipBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.pink,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${Duration(milliseconds: _audioplayerService.songcurrentPosition.value.toInt()).inMinutes}:${Duration(milliseconds: _audioplayerService.songcurrentPosition.value.toInt()).inSeconds.remainder(60).toString().padLeft(2, '0')}',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${Duration(milliseconds: _audioplayerService.songDuration.value.toInt()).inMinutes}:${Duration(milliseconds: _audioplayerService.songDuration.value.toInt()).inSeconds.remainder(60).toString().padLeft(2, '0')}',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
