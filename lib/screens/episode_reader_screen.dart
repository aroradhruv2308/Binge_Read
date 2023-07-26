// ignore_for_file: depend_on_referenced_packages

import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/db/appDto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlparser;
import 'package:selectable/selectable.dart';
import 'dart:math';

// ignore: must_be_immutable
class ReaderScreen extends StatefulWidget {
  final String url;
  final int episodeNumber;
  final List<Episode> episodes;

  ReaderScreen({super.key, required this.url, required this.episodeNumber, required this.episodes});
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
  late int pctRead;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _htmlContent = getHtmlStringFromFirebaseStorage(widget.url);
    pctRead = widget.episodes[widget.episodeNumber - 1].pctRead;
    _scrollController.addListener(_calculatePercentageRead);
  }

  void _calculatePercentageRead() {
    if (_scrollController.position.maxScrollExtent > 0) {
      double currentPosition = _scrollController.position.pixels;
      double maxScrollExtent = _scrollController.position.maxScrollExtent;
      setState(() {
        pctRead = max(pctRead, ((currentPosition / maxScrollExtent) * 100).round());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: InkWell(
          onTap: () {
            setState(() {
              Globals.isLightMode = !(Globals.isLightMode);
            });
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: Globals.isLightMode == true
                    ? const AssetImage('images/light-dark-mode.png')
                    : const AssetImage('images/dark-light-mode.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: (widget.episodeNumber != 1)
                    ? () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReaderScreen(
                                url: widget.episodes[widget.episodeNumber - 2].htmlUrl,
                                episodeNumber: widget.episodeNumber - 1,
                                episodes: widget.episodes),
                          ),
                        );
                      }
                    : null,
                child: Text(
                  " Prev ",
                  style: TextStyle(
                      color: (widget.episodeNumber == 1)
                          ? AppColors.greyColor
                          : ((Globals.isLightMode == false) ? AppColors.whiteColor : Colors.black),
                      fontFamily: 'Lexend',
                      fontSize: 16),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              TextButton(
                onPressed: (widget.episodeNumber != widget.episodes.length)
                    ? () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReaderScreen(
                                url: widget.episodes[widget.episodeNumber].htmlUrl,
                                episodeNumber: widget.episodeNumber + 1,
                                episodes: widget.episodes),
                          ),
                        );
                      }
                    : null,
                child: Text(
                  " Next ",
                  style: TextStyle(
                      color: (widget.episodeNumber == widget.episodes.length)
                          ? AppColors.greyColor
                          : ((Globals.isLightMode == false) ? AppColors.whiteColor : Colors.black),
                      fontFamily: 'Lexend',
                      fontSize: 16),
                ),
              ),
              const SizedBox(
                width: 20,
              )
            ],
          )
        ],
        leading: IconButton(
          icon: Icon(
            Icons.clear_rounded,
            color: Globals.isLightMode == true ? Colors.black : AppColors.whiteColor,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Globals.isLightMode == false ? AppColors.backgroundColor : AppColors.whiteColor,
        elevation: 0,
      ),
      body: FutureBuilder<String>(
        future: _htmlContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading HTML content'),
            );
          } else {
            return SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                color: Globals.isLightMode == true ? AppColors.whiteColor : AppColors.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 5, 28, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Episode ${widget.episodeNumber}",
                        style: TextStyle(
                          color: Globals.isLightMode == true ? AppColors.darkGreyColor : AppColors.greyColor,
                          fontSize: 16,
                          fontFamily: 'Lexend',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        pctRead.toString(),
                        style: const TextStyle(
                          color: AppColors.whiteColor,
                        ),
                      ),
                      Selectable(
                        selectWordOnDoubleTap: true,
                        child: HtmlWidget(
                          snapshot.data!,
                          textStyle: TextStyle(
                            color: Globals.isLightMode == false ? Color.fromARGB(255, 202, 205, 214) : Colors.black,
                          ),
                        ),
                      ),
                    ],
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
