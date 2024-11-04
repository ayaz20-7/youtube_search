

class ThumbnailData{
  final String url;
  final int width;
  final int height;

  ThumbnailData({required this.url, required this.width, required this.height});

  factory ThumbnailData.fromJson(Map<String,dynamic> json){
    return ThumbnailData(
      height: json['height'],
      width: json['width'],
      url: json['url']
    );
  }
}