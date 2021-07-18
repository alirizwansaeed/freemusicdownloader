import 'dart:convert';

import 'package:freemusicdownloader/Shared/FormatedString.dart';
import 'package:freemusicdownloader/Shared/decrypt_url.dart';
Song songFromJson(String str) =>
    Song.fromJson(json.decode(str));
class Song {
  Song({
    this.id='',
    this.song='',
    this.album='',
    this.year='',
    this.singers='',
    this.image='',
    this.the320Kbps='',
    this.encryptedMediaUrl='',
    this.duration='',
    this.primaryartists='',
  });

  String id;
  String song;
  String album;
  String year;
  String singers;
  String image;
  String the320Kbps;
  String encryptedMediaUrl;
  String duration;
  String primaryartists;

  factory Song.fromJson(Map<String, dynamic> json) => Song(
        id: json["id"],
        song: FormatedString.formatedString(json["song"]),
        album: FormatedString.formatedString(json["album"]),
        year: json["year"],
        singers: FormatedString.formatedString(json["singers"]),
        image: json["image"],
        the320Kbps: json["320kbps"],
        encryptedMediaUrl: DecryptUrl.decrpturl(
          json["encrypted_media_url"],
        ),
        duration: json["duration"],
        primaryartists: json["primary_artists"]
      );
}
