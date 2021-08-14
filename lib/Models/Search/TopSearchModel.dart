import 'dart:convert';

import 'package:freemusicdownloader/Models/Types/Types.dart';

TopSearchModel topSearchModelFromJson(String str) =>
    TopSearchModel.fromJson(json.decode(str));

class TopSearchModel {
  TopSearchModel({
    this.albums = const [],
    this.songs = const [],
    this.playlists = const [],
  });

  final List<SingleTopSearch> albums;
  final List<SingleTopSearch> songs;
  final List<SingleTopSearch> playlists;

  factory TopSearchModel.fromJson(Map<String, dynamic> json) => TopSearchModel(
        albums: List<SingleTopSearch>.from(
            json['albums']["data"].map((x) => SingleTopSearch.fromJson(x))),
        songs: List<SingleTopSearch>.from(
            json['songs']["data"].map((x) => SingleTopSearch.fromJson(x))),
        playlists: List<SingleTopSearch>.from(
            json['playlists']["data"].map((x) => SingleTopSearch.fromJson(x))),
      );
}

class SingleTopSearch {
  SingleTopSearch({
    this.id,
    this.title,
    this.image,
    this.type,
    this.description,
  });

  final String? id;
  final String? title;
  final String? image;

  final ContentType? type;
  final String? description;

  factory SingleTopSearch.fromJson(Map<String, dynamic> json) =>
      SingleTopSearch(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        type: chartTypeValues.map[json["type"]],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "type": type,
        "description": description,
      };
}
