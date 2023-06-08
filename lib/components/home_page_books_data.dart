import 'package:binge_read/bloc/home_screen_bloc/home_screen_bloc.dart';
import 'package:binge_read/components/ui_elements.dart';
import 'package:binge_read/screens/series_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

Widget seriesCarousel(
    {required BuildContext context,
    required HomeScreenBloc homeScreenBloc,
    required List<String> seriesThumbnailUrls,
    required List<String> nameOfSeries,
    required List<double> rating,
    required List<int> numberOfSeason,
    required List<int> numberOfViews,
    required List<List<String>> genre,
    required List<int> seriesId,
    required List<String> synopsis}) {
  var logger = Logger();

  return SizedBox(
    height: 250, // Set the desired height for the horizontal scroll
    child: ListView.builder(
      scrollDirection: Axis.horizontal, // Set the scroll direction to horizontal
      itemCount: seriesThumbnailUrls.length,
      itemBuilder: (context, index) {
        final imageUrl = seriesThumbnailUrls[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SeriesDetailScreen(
                        seriesId: seriesId[index],
                        genre: genre[index],
                        url: imageUrl,
                        title: nameOfSeries[index],
                        rating: rating[index],
                        numberOfViews: numberOfViews[index],
                        synopsis: synopsis[index],
                      )),
            );
          },
          child: seriesCard(
            context: context,
            image_url: imageUrl,
            rating: rating[index],
            number_season: numberOfSeason[index],
            series_name: nameOfSeries[index],
          ),
        );
      },
    ),
  );
}

class Series {
  final String title;

  Series({required this.title});
}
