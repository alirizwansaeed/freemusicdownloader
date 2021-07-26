import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:freemusicdownloader/Controller/DownloadController.dart';

class ProgressBar extends StatelessWidget {
  final Color randomcolor;
  ProgressBar({
    Key? key,
    required this.randomcolor,
  }) : super(key: key);
  final _downloadController = Get.find<DownloadController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LiquidLinearProgressIndicator(
        value: _downloadController.progress.value,
        valueColor: AlwaysStoppedAnimation(randomcolor),
        backgroundColor: Colors.white,
        borderColor: randomcolor,
        borderWidth: 5.0,
        borderRadius: 4.0,
        direction: Axis.horizontal,
        center: Text(
          _downloadController.progress.value == 1.0
              ? 'Completed'
              : "${(_downloadController.progress.value * 100).toInt()}%",
          style: GoogleFonts.nunito(
            color: _downloadController.progress.value >= .5
                ? Colors.white
                : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
