import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yt_search/model/item_data.dart';
import 'model/youtube_search_Model.dart';
import 'package:http/http.dart' as http;

class YoutubeSearchPage extends StatefulWidget {
  const YoutubeSearchPage({super.key});

  @override
  YoutubeSearchPageState createState() => YoutubeSearchPageState();
}

class YoutubeSearchPageState extends State<YoutubeSearchPage> {
  bool _isSearch = false;
  bool _isLoading = true;
  int navIndex = 0;
  List<ItemData> items = [];
  late String _nextPageToken;
  final ScrollController _listScrollController = ScrollController();

  final TextEditingController _controller = TextEditingController();

  String baseUrl = "https://youtube.googleapis.com/youtube/v3/";
  String APK_KEY = "AIzaSyBjGloNHkJq0fXNS9gCa-kQJhZWjffaMUY";
  static const String MAXRESULT = "10";

  final httpClient = http.Client();

  @override
  void dispose() {
    _controller.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getResult();
  }

  Future<void> _getResult() async {
    setState(() {
      _isLoading = true;
    });
    String url = "${baseUrl}search?part=snippet&maxResults=$MAXRESULT&q=${_controller.text}&videoType=any&key=$APK_KEY${_nextPageToken!=null?"&pageToken=$_nextPageToken":""}";

    final encodeFul = Uri.encodeFull(url);

    final response = await httpClient.get(encodeFul as Uri);

    if (response.statusCode == 200) {
      final data = YoutubeSearchModel.fromJson(json.decode(response.body));
      setState(() {
        _nextPageToken = data.nextPageToken;
        items = data.items;
        _isLoading = false;
      });
    }

    // final assetsData=await rootBundle.loadString("assets/youtube_search.json");
    //
    // final response=YoutubeSearchModel.fromJson(json.decode(assetsData));

    // print(response.items[0].snippet.thumbnails.high.url);
  }

  Future<void> nextPageResult() async {
    if (_nextPageToken == null) {
      //TODO:handle exception
      return;
    }
    if (_controller.text.isEmpty) {
      //TODO:handle exception
      return;
    }

    String url = "${baseUrl}search?part=snippet&maxResults=$MAXRESULT&q=${_controller.text}&videoType=any&key=$APK_KEY${_nextPageToken!=null?"&pageToken=$_nextPageToken":""}";

    final encodeFul = Uri.encodeFull(url);

    final response = await httpClient.get(encodeFul as Uri);

    if (response.statusCode == 200) {
      final data = YoutubeSearchModel.fromJson(json.decode(response.body));
      setState(() {

        _nextPageToken = data.nextPageToken;
        print(_nextPageToken);
        items += data.items;
      });
    }
  }

  Widget _searchWidget() {
    return Row(
      children: [
        InkWell(
            onTap: () {
              setState(() {
                _isSearch = false;
              });
            },
            child: const Icon(Icons.arrow_back)),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Container(
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.black.withOpacity(.2),
              ),
              child: TextField(
                controller: _controller,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    suffixIcon: InkWell(
                        onTap: () {
                          _getResult();
                        },
                        child: Icon(Icons.search)),
                    hintText: "search Youtube",
                    border: InputBorder.none),
              )),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(.1), shape: BoxShape.circle),
          child: Icon(Icons.mic),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearch == true
            ? _searchWidget()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 20,
                      child: Image.asset("assets/youtube_logo.png")),
                  Row(
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      Icon(Icons.notifications_none_outlined),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                          onTap: () {
                            if (_isSearch == false) {
                              setState(() {
                                _isSearch = true;
                              });
                            }
                          },
                          child: Icon(Icons.search)),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(28)),
                            child: Image.asset("assets/etechviral.png")),
                      ),
                    ],
                  )
                ],
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: navIndex,
        onTap: (index) {
          setState(() {
            navIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Create"),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: "Subscriptions"),
          BottomNavigationBarItem(icon: Icon(Icons.wysiwyg), label: "Libray"),
        ],
      ),
      body: _controller.text.isEmpty
          ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 48,
                    color: Colors.black.withOpacity(.4),
                  ),
                  Text(
                    "Search Data",
                    style: TextStyle(
                        fontSize: 28, color: Colors.black.withOpacity(.4)),
                  ),
                ],
              ),
            )
          : _isLoading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollNotification) {
                    if (scrollNotification is ScrollEndNotification &&
                        _listScrollController.position.extentAfter == 0) {
                      //NextPageResult;
                      nextPageResult();
                      print("reached to bottom");
                    }

                    return false;
                  },
                  child: ListView.builder(
                    controller: _listScrollController,
                    itemCount: _calculateItemLen(),
                    itemBuilder: (context, index) {
                      if (items.length == index) {
                        return _buildProgressIndicator();
                      } else
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, "/playVideo",
                                arguments: items[index]);
                          },
                          child: Container(
                            height: 280,
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    color: Colors.grey,
                                    child: Image.network(
                                      items[index]
                                          .snippet
                                          .thumbnails
                                          .medium
                                          .url,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "${items[index].snippet.title}",
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "${items[index].snippet.channelTitle}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                    },
                  ),
                ),
    );
  }

  int _calculateItemLen() {
    return items.length + 1;
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
