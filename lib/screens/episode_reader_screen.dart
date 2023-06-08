import 'package:flutter/material.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlparser;
import 'package:selectable/selectable.dart';

class MyHtmlScreen extends StatefulWidget {
  MyHtmlScreen();
  dom.Document htmlDocument = dom.Document();
  String link =
      "https://firebasestorage.googleapis.com/v0/b/binge-read-2326.appspot.com/o/HTMLFiles%2Foutput.html?alt=media&token=9662d1c2-9bd8-40df-a108-525663f03eb3&_gl=1*cb541j*_ga*MTk3MzUxMjgwLjE2ODMxMzA1NzA.*_ga_CW55HF8NVT*MTY4NjA3MTQzMi4xNS4xLjE2ODYwNzE5NTIuMC4wLjA.";
  @override
  State<MyHtmlScreen> createState() => _MyHtmlScreenState();
}

class _MyHtmlScreenState extends State<MyHtmlScreen> {
  Future<String> getHtmlStringFromFirebaseStorage(String url) async {
    final response = await http.get(Uri.parse(url));
    final document = htmlparser.parse(response.bodyBytes, encoding: 'utf-8');
    widget.htmlDocument = document;
    return document.outerHtml;
  }

  Future<String>? _htmlContent;

  @override
  void initState() {
    super.initState();
    _htmlContent = getHtmlStringFromFirebaseStorage(widget.link);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Html Screen"),
      ),
      body: FutureBuilder<String>(
        future: _htmlContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading HTML content'));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Selectable(
                  selectWordOnDoubleTap: true,
                  child: HtmlWidget(
                    snapshot.data!,
                    // Enable JavaScript execution in web view
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
