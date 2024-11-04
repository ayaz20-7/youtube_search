import 'package:flutter/material.dart';
import 'package:yt_search/youtube_search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.red.shade600,
        hintColor: Colors.redAccent.shade400,
      ),
      home: YoutubeSearchPage(),
    );
  }
}
