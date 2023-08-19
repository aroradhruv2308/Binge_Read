import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/bloc/book_detail_screen_bloc/bloc/book_detail_screen_bloc.dart';
import 'package:flutter/material.dart';

import '../Utils/global_variables.dart';
import '../db/appDto.dart';
import '../screens/episode_reader_screen.dart';

class CustomReaderScreenBottomNavBar extends StatelessWidget {
  final int currentEpisode;
  final int totalEpisodes;
  final List<Episode> episodes;
  final int seasonNumber;
  final BookDetailScreenBloc detailScreenBloc;

  const CustomReaderScreenBottomNavBar({
    super.key,
    required this.currentEpisode,
    required this.totalEpisodes,
    required this.episodes,
    required this.seasonNumber,
    required this.detailScreenBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: AppColors.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: (currentEpisode == 1)
                  ? AppColors.greyColor
                  : ((Globals.isLightMode == false) ? AppColors.whiteColor : Colors.black),
            ),
            color: AppColors.whiteColor,
            onPressed: (currentEpisode != 1)
                ? () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReaderScreen(
                          url: episodes[currentEpisode - 2].htmlUrl,
                          episodeNumber: currentEpisode - 1,
                          seasonNumber: seasonNumber,
                          detailScreenBloc: detailScreenBloc,
                          episodes: episodes,
                        ),
                      ),
                    );
                  }
                : null,
          ),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: [
                const TextSpan(
                  text: 'Episode ',
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    color: AppColors.greyColor,
                  ),
                ),
                TextSpan(
                  text: currentEpisode.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontFamily: 'Lexend',
                    color: AppColors.whiteColor,
                    fontSize: 18,
                  ),
                ),
                const TextSpan(
                  text: '  -  ',
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    color: AppColors.greyColor,
                  ),
                ),
                const TextSpan(
                  text: 'Total ',
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    color: AppColors.greyColor,
                  ),
                ),
                TextSpan(
                  text: totalEpisodes.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontFamily: 'Lexend',
                    color: AppColors.whiteColor,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward,
              color: (currentEpisode == totalEpisodes)
                  ? AppColors.greyColor
                  : ((Globals.isLightMode == false) ? AppColors.whiteColor : Colors.black),
            ),
            color: AppColors.whiteColor,
            onPressed: (currentEpisode != episodes.length)
                ? () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReaderScreen(
                            url: episodes[currentEpisode].htmlUrl,
                            episodeNumber: currentEpisode + 1,
                            seasonNumber: seasonNumber,
                            detailScreenBloc: detailScreenBloc,
                            episodes: episodes),
                      ),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
