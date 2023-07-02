import 'package:binge_read/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
  double baseFontSize = 16.0; // Base font size
  double fontSizeMultiplier = 1.0; // Font size multiplier
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
    print("It is new build!");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.text_decrease,
              size: 20,
            ),
            onPressed: () {
              // Handle the onPressed event for the trailing icon
            },
          ),
        ],
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
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
                  padding: const EdgeInsets.fromLTRB(28, 5, 28, 24),
                  child: Selectable(
                    selectWordOnDoubleTap: true,
                    child: HtmlWidget(
                      snapshot.data!,
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 202, 205, 214),
                      ),
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
