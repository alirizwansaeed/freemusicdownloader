enum ContentType { ALBUM, PLAYLIST, SONG,ARTIST }

final chartTypeValues = EnumValues({
  "album": ContentType.ALBUM,
  "playlist": ContentType.PLAYLIST,
  "song": ContentType.SONG,
  "artist":ContentType.ARTIST,
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;
  EnumValues(this.map);
  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
