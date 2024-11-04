

import 'package:yt_search/model/id_data.dart';
import 'package:yt_search/model/snippet_data.dart';

class ItemData{
  final String kind;
  final String etag;
  final IdData id;
  final SnippetData snippet;



  ItemData({required this.kind, required this.etag,required this.id,required this.snippet});

  factory ItemData.fromJson(Map<String,dynamic> json){
    return ItemData(
      kind: json['kind'],
      etag: json['etag'],
      id: IdData.fromJson(json['id']),
      snippet: SnippetData.fromJson(json['snippet'])
    );
  }
}