import 'package:freemusicdownloader/Controller/ApiController.dart';
import 'package:freemusicdownloader/Controller/AudioController.dart';
import 'package:freemusicdownloader/Controller/DownloadController.dart';
import 'package:freemusicdownloader/Controller/TogglePlayerSheetController.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AudioController());
    Get.put<ApiController>(ApiController());
    Get.put(TogglePlayersheetController(), permanent: true);
    Get.lazyPut(() => DownloadController());
  }
}
