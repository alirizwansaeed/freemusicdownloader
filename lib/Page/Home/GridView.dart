import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:freemusicdownloader/Controller/AudioPlayerController.dart';
import 'package:freemusicdownloader/Models/Types/Types.dart';
import 'package:freemusicdownloader/Page/Album/Albums.dart';
import 'package:freemusicdownloader/Page/playlist.dart/playlist.dart';
import 'package:freemusicdownloader/Shared/ImagePlaceHolder.dart';
import 'package:freemusicdownloader/Shared/ImageQuality.dart';
import 'package:get/get.dart';
import 'package:freemusicdownloader/Controller/ApiController.dart';
import 'package:page_transition/page_transition.dart';

class HomeGridView extends StatelessWidget {
  HomeGridView({Key? key, required this.list}) : super(key: key);
  final ApiController _apiController = Get.find<ApiController>();
  final _audioController = Get.find<AudioPlayerController>();
  final List list;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return true;
      },
      child: StaggeredGridView.countBuilder(
        padding: EdgeInsets.only(right: 8, left: 8, top: 20),
        crossAxisCount: 2,
        itemCount: list.length,
        staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1.12),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 8.0,
        itemBuilder: (BuildContext context, int index) => Bounce(
          duration: Duration(milliseconds: 200),
          onPressed: () async {
            if (list[index].type == ContentType.ALBUM) {
              _apiController.fetchAlbum(list[index].id);
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: Album(),
                  settings: RouteSettings(
                    arguments: {
                      "image": list[index].image,
                      "title": list[index].title,
                      "id": list[index].id,
                    },
                  ),
                ),
              );
            }
            if (list[index].type == ContentType.PLAYLIST) {
              _apiController.fetchSong(list[index].id);
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: Playlist(),
                  settings: RouteSettings(
                    arguments: {
                      "image": list[index].image,
                      "title": list[index].title,
                      "id": list[index].id,
                    },
                  ),
                ),
              );
              _apiController.fetchPlaylist(list[index].id);
            }
            if (list[index].type == ContentType.SONG) {
              await _apiController.fetchSong(list[index].id);
              _audioController
                  .loadSong([_apiController.singleSong.value], 0, '');
            }
          },
          child: _girdTiles(index),
        ),
      ),
    );
  }

  Widget _girdTiles(int index) {
    return Column(
      children: [
        Expanded(
          child: Hero(
            tag: list[index].id,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: CachedNetworkImage(
                imageUrl: ImageQuality.imageQuality(
                  value: list[index].image,
                  size: 350,
                ),
                placeholder: (context, url) => imagePlaceHolder(),
                errorWidget: (context, url, error) => imagePlaceHolder(),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          '${list[index].title}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
