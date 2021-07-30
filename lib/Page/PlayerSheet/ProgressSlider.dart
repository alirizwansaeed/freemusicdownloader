import 'package:another_xlider/another_xlider.dart';
import 'package:flutter/material.dart';
import 'package:freemusicdownloader/Controller/AudioPlayerController.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressSlider extends StatelessWidget {
  ProgressSlider({Key? key}) : super(key: key);
  final Rx<bool> _isSliderTapped = false.obs;
  final _audioController = Get.find<AudioPlayerController>();
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
                      trackHeight: _isSliderTapped.value ? 12 : 2,
                      disabledInactiveTrackColor: Colors.transparent,
                      thumbShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(
                      value: _audioController.bufferPostion.inMilliseconds
                          .toDouble(),
                      min: 0,
                      max: _audioController.duration.inMilliseconds.toDouble(),
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
                      _audioController.position.inMilliseconds.toDouble(),
                    ],
                    max: _audioController.duration.inMilliseconds.toDouble(),
                    min: 0,
                    handlerHeight: 20,
                    onDragging: (handlerIndex, lowerValue, upperValue) {
                      slidervalue(lowerValue);
                    },
                    onDragCompleted:
                        (handlerIndex, lowerValue, upperValue) async {
                      _isSliderTapped(false);
                      _audioController.seekto(slidervalue.value);
                    },
                    onDragStarted: (handlerIndex, lowerValue, upperValue) =>
                        _isSliderTapped(true),
                    trackBar: FlutterSliderTrackBar(
                      activeTrackBarHeight: _isSliderTapped.value ? 16 : 6,
                      inactiveTrackBarHeight: _isSliderTapped.value ? 14 : 4,
                      inactiveTrackBar: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300.withOpacity(.8),
                      ),
                      activeTrackBar: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [Colors.purple.shade500, Colors.pink],
                        ),
                      ),
                    ),
                    handler: FlutterSliderHandler(
                      opacity: _isSliderTapped.value ? 0 : 1,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.pink),
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
                  '${_audioController.position.inMinutes}:${_audioController.position.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${_audioController.duration.inMinutes}:${_audioController.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
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
