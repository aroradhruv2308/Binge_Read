import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/bloc/book_detail_screen_bloc/bloc/book_detail_screen_bloc.dart';
import 'package:binge_read/components/ui_elements.dart';
import 'package:binge_read/db/appDto.dart';
import 'package:binge_read/db/query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'episode_reader_screen.dart';

class SeriesDetailScreen extends StatefulWidget {
  final String title, url;
  final double rating;
  final int numberOfViews;
  final List<String> genre;
  final int seriesId;
  final String synopsis;
  const SeriesDetailScreen({
    super.key,
    this.synopsis = "No Synopsis",
    this.title = "Untitled",
    this.url = "",
    this.numberOfViews = 0,
    this.rating = 0.0,
    this.seriesId = 0,
    required this.genre,
  });

  @override
  State<SeriesDetailScreen> createState() => _SeriesDetailScreenState();
}

class _SeriesDetailScreenState extends State<SeriesDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late BookDetailScreenBloc detailScreenBloc;
  int currentSeason = 1;
  late List<Episode> episodes;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    detailScreenBloc = BookDetailScreenBloc(widget.seriesId, currentSeason);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _colorAnimation = ColorTween(
      end: AppColors.primaryColor,
      begin: AppColors.whiteColor,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    detailScreenBloc.close();
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
            ),
          ),
        ],
        title: const Text(
          "Detail",
          style: TextStyle(
            fontFamily: 'Lexend',
            fontSize: SizeConstants.eighteenPixel,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
            size: SizeConstants.eighteenPixel,
          ),
          onPressed: () {
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
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Stack(children: [
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: AppColors.glowGreen,
                                width: MediaQuery.of(context).size.width * 0.35 - 10,
                                height: MediaQuery.of(context).size.height * 0.2 - 10,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 15,
                          left: 5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.backgroundColor,
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              width: MediaQuery.of(context).size.width * 0.35 - 10,
                              height: MediaQuery.of(context).size.height * 0.2 - 15,
                              child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Image.network(
                                  widget.url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        widget.title,
                        maxLines: 2,
                        style: const TextStyle(
                          fontFamily: 'Lexend',
                          color: AppColors.whiteColor,
                          fontSize: SizeConstants.sixteenPixel,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
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
                                  fontSize: SizeConstants.twelvePixel,
                                ),
                              ),
                            ),
                            const Flexible(
                              flex: 1,
                              child: Icon(Icons.star, color: Colors.amber),
                            ),
                            Flexible(
                              flex: 5,
                              child: Text(
                                "  Total Views: ${widget.numberOfViews} ",
                                style: const TextStyle(
                                  color: AppColors.greyColor,
                                  fontFamily: "Lexend",
                                  fontSize: SizeConstants.twelvePixel,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.12,
                          child: Wrap(
                            spacing: 12.0,
                            runSpacing: 12.0,
                            children: widget.genre.map((item) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.glowGreen,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: SizeConstants.twelvePixel,
                                    fontFamily: "Lexend",
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                )
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
                  color: AppColors.whiteColor,
                  fontSize: SizeConstants.sixteenPixel,
                  fontFamily: "Lexend",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: expandableText(
                text: widget.synopsis,
                textHeight: 40,
              ),
            ),
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
                      fontSize: SizeConstants.sixteenPixel,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: SeasonDropdown(
                    seriesId: widget.seriesId,
                    numberOfSeasons: 4,
                    detailScreenBloc: detailScreenBloc,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 0, 0),
              child: BlocBuilder<BookDetailScreenBloc, BookDetailScreenState>(
                bloc: detailScreenBloc,
                builder: (context, state) {
                  if (state is ShowSeasonEpisodesState) {
                    currentSeason = state.seasonNumber ?? 1;
                    final episodes = state.episodes;

                    return Column(
                      children: List.generate(
                        episodes!.length,
                        (index) => Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Row(
                            children: [
                              Globals.isLogin
                                  ? EpisodePercentIndicatorIcon(
                                      pctRead: episodes[index].pctRead,
                                    )
                                  : const Icon(
                                      Icons.menu_book_rounded,
                                      color: AppColors.whiteColor,
                                    ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    // Here we will open the episode screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReaderScreen(
                                          url: episodes[index].htmlUrl,
                                          episodeNumber: index + 1,
                                          seasonNumber: currentSeason,
                                          detailScreenBloc: detailScreenBloc,
                                          episodes: episodes,
                                        ),
                                      ),
                                    ).then((value) => setState(() => {}));
                                  },
                                  child: episodeCard(
                                    context: context,
                                    episodes: episodes,
                                    seriesId: widget.seriesId,
                                    episodeName: episodes[index].name,
                                    episodeSummary: episodes[index].summary,
                                    episodeNumber: index + 1,
                                    episodeUrl: episodes[index].htmlUrl,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
