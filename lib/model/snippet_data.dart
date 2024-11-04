import 'package:yt_search/model/thumbnails.dart';

class SnippetData {
  final String publishedAt;
  final String channelId;
  final String title;
  final String description;
  final String channelTitle;
  final String liveBroadcastContent;
  final String publishTime;
  final Thumbnails thumbnails;

  SnippetData(
      {required this.publishedAt,
      required this.channelId,
      required this.title,
      required this.description,
      required this.channelTitle,
      required this.liveBroadcastContent,
      required this.publishTime,required this.thumbnails});

  factory SnippetData.fromJson(Map<String,dynamic> json){
    return SnippetData(
      title: json['title'],
      publishTime: json['publishTime'],
      liveBroadcastContent: json['liveBroadcastContent'],
      channelTitle: json['channelTitle'],
      publishedAt: json['publishedAt'],
      description: json['description'],
      channelId: json['channelId'],
      thumbnails: Thumbnails.fromJson(json['thumbnails']),
    );
  }
}
