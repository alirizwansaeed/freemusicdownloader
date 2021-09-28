import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:freemusicdownloader/Controller/ApiController.dart';
import 'package:freemusicdownloader/Controller/TogglePlayerSheetController.dart';
import 'package:freemusicdownloader/Shared/Detailpage.dart';

class Album extends StatelessWidget {
  Album({
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
          _apicontroller.cancelToken.cancel('album request cancel');
        }

        return _toggleplayersheet.isBottomsheetopen.value ? false : true;
      },
      child: Obx(
        () => Scaffold(
          body: Detail(
            songs: _apicontroller.albumList.value.songs,
            releaseYear: _apicontroller.albumList.value.year,
            primaryAtrist: _apicontroller.albumList.value.primaryArtists,
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
