// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/foundation.dart';

List<SearchLocaltions> locationsFromJson(List<dynamic> list) =>
    List<SearchLocaltions>.from(list.map((x) => SearchLocaltions.fromJson(x)));

String locationsToJson(List<SearchLocaltions> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchLocaltions {
  SearchLocaltions({
    @required this.id,
    @required this.name,
    @required this.region,
    @required this.country,
    @required this.lat,
    @required this.lon,
    @required this.url,
  });

  int id;
  String name;
  String region;
  String country;
  double lat;
  double lon;
  String url;

  factory SearchLocaltions.fromJson(Map<String, dynamic> json) =>
      SearchLocaltions(
        id: json["id"],
        name: json["name"],
        region: json["region"],
        country: json["country"],
        lat: json["lat"].toDouble(),
        lon: json["lon"].toDouble(),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "region": region,
        "country": country,
        "lat": lat,
        "lon": lon,
        "url": url,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
