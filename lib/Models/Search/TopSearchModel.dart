import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:freemusicdownloader/Models/Types/Types.dart';
import 'package:freemusicdownloader/Shared/FormatedString.dart';

TopSearchModel topSearchModelFromJson(String str) =>
    TopSearchModel.fromJson(json.decode(str));

class TopSearchModel {
  TopSearchModel({
    this.albums,
    this.songs,
    this.playlists,
  });

  final List<SingleTopSearch>? albums;
  final List<SingleTopSearch>? songs;
  final List<SingleTopSearch>? playlists;

  factory TopSearchModel.fromJson(Map<String, dynamic> json) => TopSearchModel(
        albums: List<SingleTopSearch>.from(
            json['albums']["data"].map((x) => SingleTopSearch.fromJson(x))),
        songs: List<SingleTopSearch>.from(
            json['songs']["data"].map((x) => SingleTopSearch.fromJson(x))),
        playlists: List<SingleTopSearch>.from(
            json['playlists']["data"].map((x) => SingleTopSearch.fromJson(x))),
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TopSearchModel &&
        listEquals(other.albums, albums) &&
        listEquals(other.songs, songs) &&
        listEquals(other.playlists, playlists);
  }

  @override
  int get hashCode => albums.hashCode ^ songs.hashCode ^ playlists.hashCode;
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
        title: FormatedString.formatedString(json["title"]),
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
