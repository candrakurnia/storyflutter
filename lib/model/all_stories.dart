// To parse this JSON data, do
//
//     final allStories = allStoriesFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'all_stories.g.dart';

AllStories allStoriesFromJson(String str) => AllStories.fromJson(json.decode(str));

String allStoriesToJson(AllStories data) => json.encode(data.toJson());
@JsonSerializable()
class AllStories {
    bool error;
    String message;
    List<ListStory> listStory;

    AllStories({
        required this.error,
        required this.message,
        required this.listStory,
    });

    factory AllStories.fromJson(Map<String, dynamic> json) => _$AllStoriesFromJson(json);
    // AllStories(
    //     error: json["error"],
    //     message: json["message"],
    //     listStory: List<ListStory>.from(json["listStory"].map((x) => ListStory.fromJson(x))),
    // );

    Map<String, dynamic> toJson() => _$AllStoriesToJson(this);
    // {
    //     "error": error,
    //     "message": message,
    //     "listStory": List<dynamic>.from(listStory.map((x) => x.toJson())),
    // };
}

@JsonSerializable()
class ListStory {
    String id;
    String name;
    String description;
    String photoUrl;
    DateTime createdAt;
    double? lat;
    double? lon;

    ListStory({
        required this.id,
        required this.name,
        required this.description,
        required this.photoUrl,
        required this.createdAt,
        this.lat,
        this.lon,
    });

    factory ListStory.fromJson(Map<String, dynamic> json) => _$ListStoryFromJson(json);
    // ListStory(
    //     id: json["id"],
    //     name: json["name"],
    //     description: json["description"],
    //     photoUrl: json["photoUrl"],
    //     createdAt: DateTime.parse(json["createdAt"]),
    //     lat: json["lat"]?.toDouble(),
    //     lon: json["lon"]?.toDouble(),
    // );

    Map<String, dynamic> toJson() => _$ListStoryToJson(this);
    // {
    //     "id": id,
    //     "name": name,
    //     "description": description,
    //     "photoUrl": photoUrl,
    //     "createdAt": createdAt.toIso8601String(),
    //     "lat": lat,
    //     "lon": lon,
    // };
}
