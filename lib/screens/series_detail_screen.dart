import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/bloc/book_detail_screen_bloc/bloc/book_detail_screen_bloc.dart';

import 'package:binge_read/components/ui_elements.dart';
import 'package:binge_read/db/appDto.dart';
import 'package:binge_read/db/query.dart';
import 'package:blur/blur.dart';
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.only(bottomLeft: Radius.circular(22), bottomRight: Radius.circular(22)),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.34,
                          child: Image.network(
                            widget.url,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              widget.url,
                              fit: BoxFit.fill,

                              // Replace with your image URL
                              // Adjust the image fit as per your need
                            ),
                          ),
                        ),
                      ).frosted(
                        blur: 1,
                        frostOpacity: 0.01,
                        frostColor: Color.fromARGB(255, 70, 69, 69),
                        borderRadius:
                            const BorderRadius.only(bottomLeft: Radius.circular(22), bottomRight: Radius.circular(22)),
                        height: MediaQuery.of(context).size.height * 0.34,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(8),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 100,
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
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                          padding: const EdgeInsets.only(right: 14),
                          child: SeasonDropdown(
                            numberOfSeasons: 4,
                            delailScreenBloc: delailScreenBloc,
                          )),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(5, 20, 0, 0),
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
                                          context: context,
                                          episodes: episodes,
                                          seriesId: widget.seriesId,
                                          episodeName: episodes[index].name,
                                          episodeSummary: episodes[index].summary,
                                          episodeNumber: index + 1,
                                          episodeUrl: episodes[index].htmlUrl),
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
              Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 12.0, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        height: 35,
                        width: 35,
                        child: Center(
                          child: IconButton(
                            iconSize: 12,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: const Icon(
                              Icons.arrow_back_ios_new_outlined,
                              color: Colors.white, // Replace with your desired color
                            ),
                            onPressed: () {
                              // Handle back button press
                              Navigator.pop(context);
                            },
                          ),
                        )).frosted(
                      frostOpacity: 0.001,
                      frostColor: AppColors.backgroundColor,
                      // frostColor: Color.fromARGB(255, 70, 69, 69),
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                    SizedBox(
                      height: 35,
                      width: 35,
                      child: GestureDetector(
                        onTap: _toggleBookmark,
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Icon(
                              Icons.bookmark,
                              size: 18,
                              color: _colorAnimation.value,
                            );
                          },
                        ),
                      ).frosted(
                        blur: 20,
                        frostOpacity: 0.001,
                        frostColor: AppColors.backgroundColor,

                        // frostColor: Color.fromARGB(255, 70, 69, 69),
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.34 - 50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: screenDetailCard(context, seriesName: widget.title),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
