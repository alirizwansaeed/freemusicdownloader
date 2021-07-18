import 'package:freemusicdownloader/Controller/ApiController.dart';
import 'package:freemusicdownloader/Controller/AudioPlayerController.dart';
import 'package:freemusicdownloader/Controller/TogglePlayerSheetController.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiController>(ApiController(), permanent: true);
    Get.put(AudioplayerController(), permanent: true);
    Get.put(TogglePlayersheetController(), permanent: true);
  }
}
