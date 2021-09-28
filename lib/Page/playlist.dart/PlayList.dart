import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:freemusicdownloader/Controller/ApiController.dart';
import 'package:freemusicdownloader/Controller/TogglePlayerSheetController.dart';
import 'package:freemusicdownloader/Shared/Detailpage.dart';

class Playlist extends StatelessWidget {
  Playlist({
    Key? key,
  }) : super(key: key);

  final _apicontroller = Get.find<ApiController>();
  final _toggleplayersheet = Get.find<TogglePlayersheetController>();

  @override
  Widget build(BuildContext context) {
    final _routedata = ModalRoute.of(context)!.settings.arguments as Map;
    return WillPopScope(
      onWillPop: () async {
        if (_toggleplayersheet.isBottomsheetopen.value == false) {
          _apicontroller.cancelToken.cancel('Playlist request cancel');

        }
        return _toggleplayersheet.isBottomsheetopen.value ? false : true;
      },
      child: Obx(
        () => Scaffold(
          body: Detail(
            songs: _apicontroller.playListList.value.songs,
            releaseYear: '',
            primaryAtrist: '',
            isLoading: _apicontroller.isloading.value,
            routeTitle: _routedata['title'],
            routeId: _routedata['id'],
            routeImage: _routedata['image'],
          ),
        ),
      ),
    );
  }
}
