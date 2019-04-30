import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:redux_example/data/model/urls_data.dart';
import 'package:redux_example/data/model/links_data.dart';
import 'package:redux_example/data/model/location_data.dart';
import 'package:redux_example/data/model/user_data.dart';
import 'package:redux_example/data/model/exif_data.dart';

class Photo {
  String color;
  DateTime createdAt;
  Urls urls;
  DateTime updatedAt;
  int downloads;
  int width;
  Links links;
  Location location;
  String id;
  User user;
  int views;
  int height;
  int likes;
  Exif exif;

  Photo({
    this.color = "",
    this.createdAt,
    this.urls,
    this.updatedAt,
    this.downloads = 0,
    this.width = 0,
    this.links,
    this.location,
    this.id = "",
    this.user,
    this.views = 0,
    this.height = 0,
    this.likes = 0,
    this.exif,
  });

  Photo.fromJson(Map<String, dynamic>  map) :
        color = map['color']  ?? "",
        createdAt = map['created_at'] == null ? null
               : DateTime.parse(map["created_at"]),
        urls = map['urls'] == null
            ? null
            : Urls.fromJson(map['urls']),
        updatedAt = map['updated_at'] == null ? null
               : DateTime.parse(map["updated_at"]),
        downloads = map['downloads']  ?? 0,
        width = map['width']  ?? 0,
        links = map['links'] == null
            ? null
            : Links.fromJson(map['links']),
        location = map['location'] == null
            ? null
            : Location.fromJson(map['location']),
        id = map['id']  ?? "",
        user = map['user'] == null
            ? null
            : User.fromJson(map['user']),
        views = map['views']  ?? 0,
        height = map['height']  ?? 0,
        likes = map['likes']  ?? 0,
        exif = map['exif'] == null
            ? null
            : Exif.fromJson(map['exif']);

  Map<String, dynamic> toJson() => {
        'color': color,
        'created_at': createdAt == null? null
               : DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt),
        'urls': urls.toJson(),
        'updated_at': updatedAt == null? null
               : DateFormat('yyyy-MM-dd HH:mm:ss').format(updatedAt),
        'downloads': downloads,
        'width': width,
        'links': links.toJson(),
        'location': location.toJson(),
        'id': id,
        'user': user.toJson(),
        'views': views,
        'height': height,
        'likes': likes,
        'exif': exif.toJson(),
      };

  Photo copyWith({
    String color,
    DateTime createdAt,
    Urls urls,
    DateTime updatedAt,
    int downloads,
    int width,
    Links links,
    Location location,
    String id,
    User user,
    int views,
    int height,
    int likes,
    Exif exif,
  }) {
    return Photo(
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      urls: urls ?? this.urls,
      updatedAt: updatedAt ?? this.updatedAt,
      downloads: downloads ?? this.downloads,
      width: width ?? this.width,
      links: links ?? this.links,
      location: location ?? this.location,
      id: id ?? this.id,
      user: user ?? this.user,
      views: views ?? this.views,
      height: height ?? this.height,
      likes: likes ?? this.likes,
      exif: exif ?? this.exif,
    );
  }

}

