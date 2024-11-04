import 'package:yt_search/model/item_data.dart';
import 'package:yt_search/model/page_info_data.dart';

class YoutubeSearchModel {
  final String kind;
  final String etag;
  final String nextPageToken;
  final String regionCode;
  final PageInfoData pageInfo;
  final List<ItemData> items;

  YoutubeSearchModel({
    required this.kind,
    required this.etag,
    required this.nextPageToken,
    required this.regionCode,
    required this.pageInfo,
    required this.items
  });

  factory YoutubeSearchModel.fromJson(Map<String,dynamic> json){
    final items=json['items'] as List;
    List<ItemData> itemData=items.map((singleItem) => ItemData.fromJson(singleItem)).toList();
    return YoutubeSearchModel(
      etag: json['kind'],
      kind: json['kind'],
      regionCode: json['regionCode'],
      nextPageToken: json['nextPageToken'],
      pageInfo: PageInfoData.fromJson(json['pageInfo']),
      items: itemData,
    );
  }

}
