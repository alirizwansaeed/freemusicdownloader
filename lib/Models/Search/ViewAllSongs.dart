import 'dart:convert';

import 'package:freemusicdownloader/Shared/FormatedString.dart';
import 'package:freemusicdownloader/Shared/decrypt_url.dart';

ViewAllSongsModel viewAllSongsModelFromJson(String str) =>
    ViewAllSongsModel.fromJson(json.decode(str));

class ViewAllSongsModel {
  ViewAllSongsModel({
    this.total = 0,
    this.results = const [],
  });

  final int total;
  final List<Result> results;
  factory ViewAllSongsModel.fromJson(Map<String, dynamic> json) =>
      ViewAllSongsModel(
        total: json["total"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );
}

class Result {
  Result({
    this.name,
    this.id,
    this.title,
    this.subtitle,
    this.headerDesc,
    this.permaUrl,
    this.image,
    this.language,
    this.year = '',
    this.playCount,
    this.explicitContent,
    this.listCount,
    this.listType,
    this.list,
    this.moreInfo,
  });
  final String? name;
  final String? id;
  final String? title;
  final String? subtitle;
  final String? headerDesc;
  final String? permaUrl;
  final String? image;
  final String? language;
  final String year;
  final String? playCount;
  final String? explicitContent;
  final String? listCount;
  final String? listType;
  final String? list;
  final MoreInfo? moreInfo;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        name: json["name"] == null
            ? null
            : FormatedString.formatedString(json["name"]),
        id: json["id"],
        year: json["year"] == null ? '' : json["year"],
        title: FormatedString.formatedString(json["title"]),
        subtitle: FormatedString.formatedString(json["subtitle"]),
        headerDesc: json["header_desc"],
        image: json["image"],
        moreInfo: json["more_info"] == null
            ? null
            : MoreInfo.fromJson(json["more_info"]),
      );
}

class MoreInfo {
  final String? the320Kbps;
  final String? encryptedMediaUrl;
  final String? album;
  MoreInfo({
    this.the320Kbps,
    this.encryptedMediaUrl,
    this.album,
  });

  factory MoreInfo.fromJson(Map<String, dynamic> json) => MoreInfo(
        album: json['album'] == null
            ? null
            : FormatedString.formatedString(json['album']),
        the320Kbps: json["320kbps"] == null ? null : json["320kbps"],
        encryptedMediaUrl: json["encrypted_media_url"] == null
            ? null
            : DecryptUrl.decrpturl(json["encrypted_media_url"]),
      );
}
