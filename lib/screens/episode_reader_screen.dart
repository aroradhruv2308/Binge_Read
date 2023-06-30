import 'package:binge_read/Utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlparser;
import 'package:selectable/selectable.dart';

class ReaderScreen extends StatefulWidget {
  final String url;
  ReaderScreen({super.key, required this.url});
  dom.Document htmlDocument = dom.Document();

  @override
  State<ReaderScreen> createState() => ReaderScreenState();
}

class ReaderScreenState extends State<ReaderScreen> {
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
    _htmlContent = getHtmlStringFromFirebaseStorage(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.clear_rounded,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        title: const Text(
          "Html Screen",
          style: TextStyle(fontFamily: 'Lexend', fontSize: 18, fontWeight: FontWeight.normal),
        ),
      ),
      body: FutureBuilder<String>(
        future: _htmlContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading HTML content'));
          } else {
            return SingleChildScrollView(
              child: Container(
                color: AppColors.backgroundColor,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Selectable(
                    selectWordOnDoubleTap: true,
                    child: HtmlWidget(
                      snapshot.data!,
                      textStyle: const TextStyle(color: AppColors.greyColor),
                      // Enable JavaScript execution in web view
                    ),
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
