

import 'package:freemusicdownloader/Models/Types/Types.dart';
import 'package:freemusicdownloader/Shared/FormatedString.dart';
import 'dart:convert';


MainPageModel mainPageModelFromJson(String str) =>
    MainPageModel.fromJson(json.decode(str));

class MainPageModel {
  MainPageModel({
     this.newTrending=const[],
     this.topPlaylists=const[],
     this.newAlbums=const[],
     this.charts=const[],
  });
  List<NewTrending>? newTrending;
  List<TopPlaylist>? topPlaylists;
  List<NewAlbum>? newAlbums;
  List<Chart>? charts;
  factory MainPageModel.fromJson(Map<String, dynamic> json) => MainPageModel(
        newTrending: List<NewTrending>.from(
            json["new_trending"].map((x) => NewTrending.fromJson(x))),
        topPlaylists: List<TopPlaylist>.from(
            json["top_playlists"].map((x) => TopPlaylist.fromJson(x))),
        newAlbums: List<NewAlbum>.from(
            json["new_albums"].map((x) => NewAlbum.fromJson(x))),
        charts: List<Chart>.from(json["charts"].map((x) => Chart.fromJson(x))),
      );
}

class Chart {
  Chart({
     this.id='',
     this.title='',
     this.type,
     this.image='',
  });
  String id;
  String title;
  ContentType? type;
  String? image;
  factory Chart.fromJson(Map<String, dynamic> json) => Chart(
        id: json["id"],
        title: FormatedString.formatedString(json["title"]),
        type: chartTypeValues.map[json["type"]],
        image: json["image"],
      );
}

class NewAlbum {
  NewAlbum({
     this.id='',
     this.title='',
     this.type,
     this.image='',
  });
  String id;
  String title;
  ContentType? type;
  String image;
  factory NewAlbum.fromJson(Map<String, dynamic> json) => NewAlbum(
      id: json["id"],
      title: FormatedString.formatedString(json["title"]),
      type: chartTypeValues.map[json["type"]],
      image: json["image"]);
}

class NewTrending {
  NewTrending({
     this.id='',
     this.title='',
     this.type,
     this.image='',
  });
  String id;
  String title;
  ContentType? type;
  String image;
  factory NewTrending.fromJson(Map<String, dynamic> json) => NewTrending(
      id: json["id"],
      title: FormatedString.formatedString(json["title"]),
      type: chartTypeValues.map[json["type"]],
      image: json["image"]);
}

class TopPlaylist {
  TopPlaylist({
    this.id = '',
    this.title = '',
    this.type,
    this.image = '',
  });
  String id;
  String title;
  ContentType? type;
  String image;

  factory TopPlaylist.fromJson(Map<String, dynamic> json) => TopPlaylist(
      id: json["id"],
      title: FormatedString.formatedString(json["title"]),
      type: chartTypeValues.map[json["type"]],
      image: json["image"]);
}

