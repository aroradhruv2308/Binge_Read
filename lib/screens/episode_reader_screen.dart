import 'package:binge_read/components/custom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class MyHtmlScreen extends StatefulWidget {
  MyHtmlScreen();
  String link =
      "https://firebasestorage.googleapis.com/v0/b/binge-read-2326.appspot.com/o/Episode3.html?alt=media&token=82331269-ebd1-4a14-a326-8ad4546ba770";
  @override
  State<MyHtmlScreen> createState() => _MyHtmlScreenState();
}

class _MyHtmlScreenState extends State<MyHtmlScreen> {
  Future<String> getHtmlStringFromFirebaseStorage(String url) async {
    final response = await http.get(Uri.parse(url));
    final document = parser.parse(response.body);
    return document.outerHtml;
  }

  Future<String>? _htmlContent;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _htmlContent = getHtmlStringFromFirebaseStorage(widget.link);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          bottomNavigationBar: BottomNavBar(
            selectedIndex: 0,
            onItemTapped: (int selectedIndex) {
              print(selectedIndex);
            },
          ),
          appBar: AppBar(
            title: Text('HTML Screen'),
          ),
          body: FutureBuilder<String>(
            future: _htmlContent,
            builder: (context, snapshot) {
              print(snapshot.data);

              return SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: HtmlWidget(snapshot.data.toString()),
              ));
            },
          )),
    );
  }
}
