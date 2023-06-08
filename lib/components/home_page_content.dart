import 'package:binge_read/Utils/animations.dart';
import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/bloc/home_screen_bloc/home_screen_bloc.dart';
import 'package:binge_read/db/home_screen_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'home_page_books_data.dart';

class HomePageContent extends StatefulWidget {
  HomeScreenBloc homeScreenBloc = HomeScreenBloc();
  HomePageContent({super.key, homeScreenBloc});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  List<String> seriesThumbnailUrls = [];
  List<String> nameOfSeries = [];
  List<double> rating = [];
  List<int> numberOfSeason = [];
  List<int> numberOfViews = [];
  List<List<String>> genre = [];
  List<int> seriesId = [];
  List<String> synopsis = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
      child: FutureBuilder(
        future: getALLSeries(), // Replace with your actual future or async operation
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator or placeholder while waiting for data
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Handle any errors that occurred during the async operation
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<QueryDocumentSnapshot<Map<String, dynamic>>>? documents = snapshot.data;
            for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documents!) {
              String thumbnailURL = doc.get('Thumbnail URL');
              numberOfSeason.add(doc.get('number_of_seasons') as int);
              seriesThumbnailUrls.add(thumbnailURL);
              rating.add(doc.get('rating') as double);
              nameOfSeries.add(doc.get('series_name') as String);
              numberOfViews.add(doc.get('total_views') as int);
              seriesId.add(doc.get('series_id') as int);
              synopsis.add(doc.get('about') as String);
              List<dynamic> genreData = doc.get('genre') as List<dynamic>;
              List<String> currentGenre = List<String>.from(genreData.map((item) => item.toString()));
              genre.add(currentGenre);
            }
            // Use the retrieved data to build the content of the bottom sheet
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Trending",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lexend',
                      fontSize: SizeConstants.twentyTwoPixel,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  seriesCarousel(
                      synopsis: synopsis,
                      context: context,
                      homeScreenBloc: widget.homeScreenBloc,
                      seriesThumbnailUrls: seriesThumbnailUrls,
                      nameOfSeries: nameOfSeries,
                      rating: rating,
                      numberOfSeason: numberOfSeason,
                      numberOfViews: numberOfViews,
                      genre: genre,
                      seriesId: seriesId),
                  const SizedBox(height: 20),
                  const Text(
                    "Most Viewed",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lexend',
                      fontSize: SizeConstants.twentyTwoPixel,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  seriesCarousel(
                      synopsis: synopsis,
                      context: context,
                      homeScreenBloc: widget.homeScreenBloc,
                      seriesThumbnailUrls: seriesThumbnailUrls,
                      nameOfSeries: nameOfSeries,
                      rating: rating,
                      numberOfSeason: numberOfSeason,
                      numberOfViews: numberOfViews,
                      genre: genre,
                      seriesId: seriesId),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
