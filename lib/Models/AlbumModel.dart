import 'package:freemusicdownloader/Models/SingleSong.dart';
import 'dart:convert';

import 'package:freemusicdownloader/Shared/FormatedString.dart';

SingleAlbumModel singleAlbumFromJson(String str) =>
    SingleAlbumModel.fromJson(json.decode(str));

class SingleAlbumModel {
  SingleAlbumModel({
     this.year='',
     this.primaryArtists='',
     this.albumid='',
     this.songs=const[],
  });

  String year;
  String primaryArtists;
  String albumid;
  List<Song> songs;
  factory SingleAlbumModel.fromJson(Map<String, dynamic> json) =>
      SingleAlbumModel(
        year: json["year"],
        primaryArtists: FormatedString.formatedString(json["primary_artists"]),
        albumid: json["albumid"],
        songs: List<Song>.from(json["songs"].map((x) => Song.fromJson(x))),
      );
}
