import 'dart:convert';
import 'package:intl/intl.dart';

class Links {
  String followers;
  String portfolio;
  String following;
  String self;
  String html;
  String photos;
  String likes;

  Links({
    this.followers = "",
    this.portfolio = "",
    this.following = "",
    this.self = "",
    this.html = "",
    this.photos = "",
    this.likes = "",
  });

  Links.fromJson(Map<String, dynamic>  map) :
        followers = map['followers']  ?? "",
        portfolio = map['portfolio']  ?? "",
        following = map['following']  ?? "",
        self = map['self']  ?? "",
        html = map['html']  ?? "",
        photos = map['photos']  ?? "",
        likes = map['likes']  ?? "";

  Map<String, dynamic> toJson() => {
        'followers': followers,
        'portfolio': portfolio,
        'following': following,
        'self': self,
        'html': html,
        'photos': photos,
        'likes': likes,
      };

  Links copyWith({
    String followers,
    String portfolio,
    String following,
    String self,
    String html,
    String photos,
    String likes,
  }) {
    return Links(
      followers: followers ?? this.followers,
      portfolio: portfolio ?? this.portfolio,
      following: following ?? this.following,
      self: self ?? this.self,
      html: html ?? this.html,
      photos: photos ?? this.photos,
      likes: likes ?? this.likes,
    );
  }

}

