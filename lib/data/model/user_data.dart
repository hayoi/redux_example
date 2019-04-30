import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:redux_example/data/model/links_data.dart';
import 'package:redux_example/data/model/profileimage_data.dart';

class User {
  int totalPhotos;
  String twitterUsername;
  String lastName;
  String bio;
  int totalLikes;
  String portfolioUrl;
  ProfileImage profileImage;
  DateTime updatedAt;
  String name;
  String location;
  Links links;
  int totalCollections;
  String id;
  String firstName;
  String instagramUsername;
  String username;

  User({
    this.totalPhotos = 0,
    this.twitterUsername = "",
    this.lastName = "",
    this.bio = "",
    this.totalLikes = 0,
    this.portfolioUrl = "",
    this.profileImage,
    this.updatedAt,
    this.name = "",
    this.location = "",
    this.links,
    this.totalCollections = 0,
    this.id = "",
    this.firstName = "",
    this.instagramUsername = "",
    this.username = "",
  });

  User.fromJson(Map<String, dynamic>  map) :
        totalPhotos = map['total_photos']  ?? 0,
        twitterUsername = map['twitter_username']  ?? "",
        lastName = map['last_name']  ?? "",
        bio = map['bio']  ?? "",
        totalLikes = map['total_likes']  ?? 0,
        portfolioUrl = map['portfolio_url']  ?? "",
        profileImage = map['profile_image'] == null
            ? null
            : ProfileImage.fromJson(map['profile_image']),
        updatedAt = map['updated_at'] == null ? null
               : DateTime.parse(map["updated_at"]),
        name = map['name']  ?? "",
        location = map['location']  ?? "",
        links = map['links'] == null
            ? null
            : Links.fromJson(map['links']),
        totalCollections = map['total_collections']  ?? 0,
        id = map['id']  ?? "",
        firstName = map['first_name']  ?? "",
        instagramUsername = map['instagram_username']  ?? "",
        username = map['username']  ?? "";

  Map<String, dynamic> toJson() => {
        'total_photos': totalPhotos,
        'twitter_username': twitterUsername,
        'last_name': lastName,
        'bio': bio,
        'total_likes': totalLikes,
        'portfolio_url': portfolioUrl,
        'profile_image': profileImage.toJson(),
        'updated_at': updatedAt == null? null
               : DateFormat('yyyy-MM-dd HH:mm:ss').format(updatedAt),
        'name': name,
        'location': location,
        'links': links.toJson(),
        'total_collections': totalCollections,
        'id': id,
        'first_name': firstName,
        'instagram_username': instagramUsername,
        'username': username,
      };

  User copyWith({
    int totalPhotos,
    String twitterUsername,
    String lastName,
    String bio,
    int totalLikes,
    String portfolioUrl,
    ProfileImage profileImage,
    DateTime updatedAt,
    String name,
    String location,
    Links links,
    int totalCollections,
    String id,
    String firstName,
    String instagramUsername,
    String username,
  }) {
    return User(
      totalPhotos: totalPhotos ?? this.totalPhotos,
      twitterUsername: twitterUsername ?? this.twitterUsername,
      lastName: lastName ?? this.lastName,
      bio: bio ?? this.bio,
      totalLikes: totalLikes ?? this.totalLikes,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      profileImage: profileImage ?? this.profileImage,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      location: location ?? this.location,
      links: links ?? this.links,
      totalCollections: totalCollections ?? this.totalCollections,
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      instagramUsername: instagramUsername ?? this.instagramUsername,
      username: username ?? this.username,
    );
  }

}

class Login {
  String name;
  String password;

  Login(this.name, this.password);

  Map<String, dynamic> toJson() => {
        'name': name,
        'password': password,
      };
}
