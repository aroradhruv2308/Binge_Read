// ignore_for_file: unused_import

import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/bloc/home_screen_bloc/home_screen_bloc.dart';
import 'package:binge_read/components/ui_elements.dart';
import 'package:binge_read/screens/series_detail_screen.dart';
import 'package:flutter/material.dart';

Widget seriesCarousel({
  required BuildContext context,
  required HomeScreenBloc homeScreenBloc,
  required List<dynamic> seriesDataList,
}) {
  return Container(
    constraints: const BoxConstraints(maxHeight: 150),
    height: MediaQuery.of(context).size.height * 0.22,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: seriesDataList.length,
      itemBuilder: (context, index) {
        final imageUrl = seriesDataList[index]['Thumbnail URL'];
        final genre = seriesDataList[index]['genre'];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SeriesDetailScreen(
                  seriesId: seriesDataList[index]['series_id'],
                  genre: List<String>.from(genre.map((item) => item.toString())),
                  url: imageUrl,
                  title: seriesDataList[index]['series_name'],
                  rating: seriesDataList[index]['rating'],
                  numberOfViews: seriesDataList[index]['total_views'],
                  synopsis: seriesDataList[index]['about'],
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: seriesCard(
              context: context,
              imageUrl: imageUrl,
              rating: seriesDataList[index]['rating'],
              numberSeason: seriesDataList[index]['number_of_seasons'],
              seriesName: seriesDataList[index]['series_name'],
            ),
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
