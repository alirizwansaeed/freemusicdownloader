import 'package:freemusicdownloader/Models/SingleSong.dart';
import 'package:freemusicdownloader/Shared/FormatedString.dart';
import 'dart:convert';

PlaylistModel playlistFromJson(String str) =>
    PlaylistModel.fromJson(json.decode(str));

class PlaylistModel {
  PlaylistModel({
    this.listid = '',
    this.listname = '',
    this.image = '',
    this.songs = const [],
  });

  final String listid;
  final String listname;
  final String image;
  final List<Song> songs;

  factory PlaylistModel.fromJson(Map<String, dynamic> json) => PlaylistModel(
        listid: json["listid"],
        listname: FormatedString.formatedString(json["listname"]),
        image: json["image"],
        songs: List<Song>.from(json["songs"].map((x) => Song.fromJson(x))),
      );
}
