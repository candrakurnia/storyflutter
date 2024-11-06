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
 
    Map<String, dynamic> toJson() => _$DetailStoriesToJson(this);
    
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
    

    Map<String, dynamic> toJson() => _$StoryToJson(this);
    
}
