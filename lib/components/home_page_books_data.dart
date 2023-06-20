import 'package:binge_read/bloc/home_screen_bloc/home_screen_bloc.dart';
import 'package:binge_read/components/ui_elements.dart';
import 'package:binge_read/screens/series_detail_screen.dart';
import 'package:flutter/material.dart';

Widget seriesCarousel(
    {required BuildContext context, required HomeScreenBloc homeScreenBloc, required List<dynamic> seriesDataList}) {
  return SizedBox(
    height: 250, // Set the desired height for the horizontal scroll
    child: ListView.builder(
      scrollDirection: Axis.horizontal, // Set the scroll direction to horizontal
      itemCount: seriesDataList.length,
      itemBuilder: (context, index) {
        final imageUrl = seriesDataList[index]['Thumbnail URL'];
        final genre = seriesDataList[index]['genre'];
        return InkWell(
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
                      )),
            );
          },
          child: seriesCard(
            context: context,
            image_url: imageUrl,
            rating: seriesDataList[index]['rating'],
            number_season: seriesDataList[index]['number_of_seasons'],
            series_name: seriesDataList[index]['series_name'],
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
