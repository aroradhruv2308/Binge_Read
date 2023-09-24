// ignore_for_file: depend_on_referenced_packages

import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/Utils/util_functions.dart';
import 'package:binge_read/db/appDto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlparser;
import 'package:selectable/selectable.dart';
import 'dart:math';

import 'package:binge_read/bloc/book_detail_screen_bloc/bloc/book_detail_screen_bloc.dart';

import '../components/bottom_sheet_switch.dart';
import '../components/custom_reader_screen_bottom_navbar.dart';
import '../db/query.dart';

// ignore: must_be_immutable
class ReaderScreen extends StatefulWidget {
  final String url;
  final int episodeNumber;
  final int seasonNumber;
  final BookDetailScreenBloc detailScreenBloc;
  final List<Episode> episodes;
  final int seriesId;

  ReaderScreen({
    super.key,
    required this.seriesId,
    required this.url,
    required this.episodeNumber,
    required this.seasonNumber,
    required this.detailScreenBloc,
    required this.episodes,
  });
  dom.Document htmlDocument = dom.Document();

  @override
  State<ReaderScreen> createState() => ReaderScreenState();
}

class ReaderScreenState extends State<ReaderScreen> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  Future<String> getHtmlStringFromFirebaseStorage(String url) async {
    final response = await http.get(Uri.parse(url));
    final document = htmlparser.parse(response.bodyBytes, encoding: 'utf-8');
    widget.htmlDocument = document;
    return document.outerHtml;
  }

  Future<String>? _htmlContent;
  late int pctRead;
  late String? episodeId;
  late int totalEpisodes;
  bool isLiked = false;

  double fontSize = SizeConstants.twelvePixel;
  int currentMultiplierIndex = 1;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _htmlContent = getHtmlStringFromFirebaseStorage(widget.url);
    pctRead = widget.episodes[widget.episodeNumber - 1].pctRead;
    episodeId = widget.episodes[widget.episodeNumber - 1].episodeId;
    totalEpisodes = widget.episodes.length;

    isLiked = Globals.userMetaData?['episodes_bookmark'].any((map) => map['id'] == episodeId);

    // Adding listener to scroll event i.e. whenever user will
    // scroll on the reader screen we will update percent read.
    _scrollController.addListener(_calculatePercentageRead);

    // Register the class as observer for lifecycle methods.
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // This can happen when user presses home button to put the
      // app in recents, then our app will be in pause state. We
      // will update the calculated pctRead in DB.
      _updatePctReadInDatabase();
    }
  }

  @override
  void dispose() {
    // Remove this class as an observer when the widget is disposed.
    WidgetsBinding.instance.removeObserver(this);

    // Update percent Read if user navigates to back to previous screen.
    _updatePctReadInDatabase();
    super.dispose();
  }

  void _updatePctReadInDatabase() {
    int currPctRead = widget.episodes[widget.episodeNumber - 1].pctRead;

    // Update DB only if pctRead calculated not equal to currentPctRead i.e.
    // the one which is already stored in db.
    if (pctRead != currPctRead) {
      String? episodeId = widget.episodes[widget.episodeNumber - 1].episodeId;
      updatePctReadForEpisode(episodeId, pctRead);

      // Before updating percentRead emit reset event, which will bring the
      // bloc in loading state. After updating we will again trigger season
      // episode event to display latest updated data.
      widget.detailScreenBloc.add(ResetEvent());

      // Update percent read in local data. We can update local episodes
      // by triggering updatePercentRead event. Also update pctRead in
      // Globals userMetaData as we only fetch userMeta data once, so we
      // have to be consistent.
      Globals.userMetaData?["episodes"] ??= {};
      Globals.userMetaData?["episodes"][episodeId] ??= {};
      Globals.userMetaData?["episodes"][episodeId]["pct_read"] = pctRead;

      widget.detailScreenBloc.add(
        UpdatePercentReadEvent(
          seasonNumber: widget.seasonNumber,
          episodeNumber: widget.episodeNumber,
          percentRead: pctRead,
        ),
      );
    }
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

  void handleLike() async {
    toggleLike(isLiked, episodeId);
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: handleLike,
                child: Icon(
                  Icons.favorite,
                  color: isLiked ? AppColors.pinkColor : AppColors.whiteColor,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Globals.isLightMode ? AppColors.backgroundColor : AppColors.whiteColor,
                ),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return BottomSheetSwitch(
                          switchValue: Globals.isLightMode,
                          valueChanged: (value) {
                            setState(() {
                              Globals.isLightMode = value;
                            });
                          },
                          currentMultiplierIndex: currentMultiplierIndex,
                          fontSizeMultiplierChange: (index, value) {
                            setState(() {
                              fontSize = 14.0 * value;
                              currentMultiplierIndex = index;
                            });
                          });
                    },
                  );
                },
              ),
              const SizedBox(
                width: 5,
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
      bottomNavigationBar: CustomReaderScreenBottomNavBar(
          currentEpisode: widget.episodeNumber,
          totalEpisodes: totalEpisodes,
          episodes: widget.episodes,
          seasonNumber: widget.seasonNumber,
          detailScreenBloc: widget.detailScreenBloc,
          seriesId: widget.seriesId),
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
                          fontSize: fontSize + 2,
                          fontFamily: 'Lexend',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Selectable(
                        selectWordOnDoubleTap: true,
                        child: HtmlWidget(
                          snapshot.data!,
                          textStyle: TextStyle(
                            color:
                                Globals.isLightMode == false ? const Color.fromARGB(255, 202, 205, 214) : Colors.black,
                            fontSize: fontSize,
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
