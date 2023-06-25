import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/bloc/book_detail_screen_bloc/bloc/book_detail_screen_bloc.dart';

import 'package:binge_read/components/ui_elements.dart';
import 'package:binge_read/db/appDto.dart';
import 'package:binge_read/db/query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeriesDetailScreen extends StatefulWidget {
  String title, url;
  double rating;
  int numberOfViews;
  List<String> genre;
  int seriesId;
  String synopsis;
  SeriesDetailScreen(
      {super.key,
      this.synopsis = "No Synopsis",
      this.title = "Untitled",
      this.url = "",
      this.numberOfViews = 0,
      this.rating = 0.0,
      this.seriesId = 0,
      required this.genre});

  @override
  State<SeriesDetailScreen> createState() => _SeriesDetailScreenState();
}

class _SeriesDetailScreenState extends State<SeriesDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late BookDetailScreenBloc delailScreenBloc;
  int currentSeason = 1;

  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _colorAnimation = ColorTween(
      end: AppColors.primaryColor,
      begin: AppColors.whiteColor,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
      if (isBookmarked) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void didChangeDependencies() {
    delailScreenBloc = BookDetailScreenBloc();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: _toggleBookmark,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Icon(
                      Icons.bookmark,
                      color: _colorAnimation.value,
                    );
                  },
                ),
              ))
        ],
        title: Text(
          "Detail",
          style: const TextStyle(fontFamily: 'Lexend'),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined, // Replace with your desired icon
            color: Colors.white, // Replace with your desired color
          ),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Stack(children: [
                        Container(
                          color: AppColors.backgroundColor,
                          width: MediaQuery.of(context).size.width * 0.45,
                        ),
                        Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              color: AppColors.glowGreen,
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: MediaQuery.of(context).size.height * 0.2,
                            )),
                        Positioned(
                          top: 15,
                          left: 5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.backgroundColor,
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3), // horizontal, vertical offset
                                  ),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Image.network(
                                widget.url,
                                fit: BoxFit.fill,

                                // Replace with your image URL
                                // Adjust the image fit as per your need
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                Flexible(
                    flex: 4,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Flex(
                        direction: Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            widget.title,
                            maxLines: 2,
                            style: const TextStyle(fontFamily: 'Lexend', color: AppColors.whiteColor, fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Flex(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              direction: Axis.horizontal,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    "${widget.rating} ",
                                    style: const TextStyle(
                                      color: AppColors.greyColor,
                                      fontFamily: "Lexend",
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: SizeConstants.sixteenPixel,
                                    ),
                                  ),
                                ),
                                const Flexible(
                                  flex: 1,
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                ),
                                Flexible(
                                  flex: 5,
                                  child: Text(
                                    "  Total Views: ${widget.numberOfViews} ",
                                    style: const TextStyle(
                                      color: AppColors.greyColor,
                                      fontFamily: "Lexend",
                                      fontSize: SizeConstants.sixteenPixel,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * 0.12,
                            ),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.12,
                              child: Scrollbar(
                                isAlwaysShown: true,
                                controller: ScrollController(),
                                child: SingleChildScrollView(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Wrap(
                                    spacing: 12.0,
                                    runSpacing: 12.0,
                                    children: widget.genre.map((item) {
                                      return ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: widget.genre.length < 2
                                              ? MediaQuery.of(context).size.width * 0.3
                                              : MediaQuery.of(context).size.width * 0.22,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          color: AppColors.glowGreen,
                                          child: Text(
                                            item,
                                            style: TextStyle(fontSize: 16),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Synopsis',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Lexend',
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w100,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: expandableText(
                  text: widget.synopsis,
                  textHeight: 100,
                )),
            const SizedBox(
              height: 40,
            ),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Episodes',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Lexend',
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w100,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(right: 14),
                    child: SeasonDropdown(
                      numberOfSeasons: 4,
                      delailScreenBloc: delailScreenBloc,
                    )),
              ],
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(5, 20, 0, 0),
                child: BlocBuilder<BookDetailScreenBloc, BookDetailScreenState>(
                  bloc: delailScreenBloc,
                  builder: (context, state) {
                    if (state is ShowSeasonEpisodesState) {
                      currentSeason = state.seasonNumber ?? 1;
                    }
                    delailScreenBloc.add(ResetEvent());
                    return FutureBuilder<List<Episode>>(
                      future: fetchEpisodes(
                          seriesId: widget.seriesId,
                          seasonId: currentSeason), // Replace with your actual future that fetches the episodes
                      builder: (BuildContext context, AsyncSnapshot<List<Episode>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // While waiting for the future to complete
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          // If an error occurred
                          return Text('Error: ${snapshot.error}');
                        } else {
                          // If the future completed successfully
                          final episodes = snapshot.data!; // Access the episodes from the snapshot

                          return Column(
                            children: List.generate(
                              episodes.length,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: episodeCard(
                                  episodeName: episodes[index].name,
                                  episodeSummary: episodes[index].summary,
                                  episodeNumber: index + 1,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}
