// To parse this JSON data, do
//
//     final detailStories = detailStoriesFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'detail_stories.g.dart';

DetailStories detailStoriesFromJson(String str) => DetailStories.fromJson(json.decode(str));

String detailStoriesToJson(DetailStories data) => json.encode(data.toJson());
@JsonSerializable()
class DetailStories {
    bool error;
    String message;
    Story story;

    DetailStories({
        required this.error,
        required this.message,
        required this.story,
    });

    factory DetailStories.fromJson(Map<String, dynamic> json) => _$DetailStoriesFromJson(json);
    // DetailStories(
    //     error: json["error"],
    //     message: json["message"],
    //     story: Story.fromJson(json["story"]),
    // );

    Map<String, dynamic> toJson() => _$DetailStoriesToJson(this);
    // {
    //     "error": error,
    //     "message": message,
    //     "story": story.toJson(),
    // };
}
@JsonSerializable()
class Story {
    String id;
    String name;
    String description;
    String photoUrl;
    DateTime createdAt;
    double? lat;
    double? lon;

    Story({
        required this.id,
        required this.name,
        required this.description,
        required this.photoUrl,
        required this.createdAt,
        this.lat,
        this.lon,
    });

    factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
    // Story(
    //     id: json["id"],
    //     name: json["name"],
    //     description: json["description"],
    //     photoUrl: json["photoUrl"],
    //     createdAt: DateTime.parse(json["createdAt"]),
    //     lat: json["lat"],
    //     lon: json["lon"],
    // );

    Map<String, dynamic> toJson() => _$StoryToJson(this);
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
