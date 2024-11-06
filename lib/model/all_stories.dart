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
    

    Map<String, dynamic> toJson() => _$AllStoriesToJson(this);
    
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
   

    Map<String, dynamic> toJson() => _$ListStoryToJson(this);
    
}
