import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart';

class EpisodeScreen extends StatefulWidget {
  const EpisodeScreen({super.key});

  @override
  State<EpisodeScreen> createState() => _EpisodeScreenState();
}

String testUrl =
    '''https://firebasestorage.googleapis.com/v0/b/binge-read-2326.appspot.com/o/Episode3.html?alt=media&token=82331269-ebd1-4a14-a326-8ad4546ba770''';
Uri uri = Uri.parse(testUrl);

class _EpisodeScreenState extends State<EpisodeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(leading: Text("Approach 2")),
        body: HtmlWidget("", baseUrl: uri),
      ),
    );
  }
}
