import 'package:get/get.dart';

class TogglePlayersheetController extends GetxController {
  Rx<bool> isBottomsheetopen = false.obs;

  void bottomSheetfunction(bool value) {
    print('newvalue $value');
    isBottomsheetopen(value);
  }
}
