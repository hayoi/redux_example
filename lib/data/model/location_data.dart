import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:redux_example/data/model/position_data.dart';

class Location {
  String country;
  String city;
  String name;
  Position position;
  String title;

  Location({
    this.country = "",
    this.city = "",
    this.name = "",
    this.position,
    this.title = "",
  });

  Location.fromJson(Map<String, dynamic>  map) :
        country = map['country']  ?? "",
        city = map['city']  ?? "",
        name = map['name']  ?? "",
        position = map['position'] == null
            ? null
            : Position.fromJson(map['position']),
        title = map['title']  ?? "";

  Map<String, dynamic> toJson() => {
        'country': country,
        'city': city,
        'name': name,
        'position': position.toJson(),
        'title': title,
      };

  Location copyWith({
    String country,
    String city,
    String name,
    Position position,
    String title,
  }) {
    return Location(
      country: country ?? this.country,
      city: city ?? this.city,
      name: name ?? this.name,
      position: position ?? this.position,
      title: title ?? this.title,
    );
  }

}

