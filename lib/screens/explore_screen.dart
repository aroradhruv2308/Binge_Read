import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/bloc/home_screen_bloc/home_screen_bloc.dart';
import 'package:binge_read/components/home_page_books_data.dart';
import 'package:binge_read/db/explore_screen_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  var logger = Logger();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.greyColor),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.search, color: Colors.grey),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Your Series..',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
              future: getAllGenere(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<QueryDocumentSnapshot<Map<String, dynamic>>>? documents = snapshot.data;
                  if (documents != null && documents.isNotEmpty) {
                    QueryDocumentSnapshot<Map<String, dynamic>> firstDocument = documents[0];
                    dynamic genreList = firstDocument.get('genre');
                    return ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(genreList.length, (index) {
                            String genre = genreList[index];
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        genre,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Lexend',
                                          fontSize: SizeConstants.twentyTwoPixel,
                                          color: AppColors.whiteColor,
                                        ),
                                      ),
                                      Text(
                                        'view-all',
                                        style: TextStyle(
                                            fontFamily: 'Lexend',
                                            fontSize: SizeConstants.twelvePixel,
                                            color: AppColors.greyColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 40),
                                  FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                                    future: getBooksForAGenre(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(child: Text('Error: ${snapshot.error}'));
                                      } else {
                                        List<String> seriesThumbnailUrls = [];
                                        List<String> nameOfSeries = [];
                                        List<double> rating = [];
                                        List<int> numberOfSeason = [];
                                        List<int> numberOfViews = [];
                                        List<List<String>> allGenreList = [];
                                        List<int> seriesId = [];
                                        List<String> synopsis = [];
                                        List<QueryDocumentSnapshot<Map<String, dynamic>>>? documents = snapshot.data;
                                        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documents!) {
                                          dynamic genreArray = doc.get('genre');
                                          List<dynamic> genreData = genreArray as List<dynamic>;
                                          List<String> currentGenre =
                                              List<String>.from(genreData.map((item) => item.toString()));
                                          allGenreList.add(currentGenre);
                                          if (genreArray.contains(genre)) {
                                            String thumbnailURL = doc.get('Thumbnail URL');
                                            numberOfSeason.add(doc.get('number_of_seasons') as int);
                                            seriesThumbnailUrls.add(thumbnailURL);
                                            rating.add(doc.get('rating') as double);
                                            nameOfSeries.add(doc.get('series_name') as String);
                                            numberOfViews.add(doc.get('total_views') as int);
                                            seriesId.add(doc.get('series_id') as int);
                                            synopsis.add(doc.get('about') as String);
                                          }
                                        }

                                        return seriesCarousel(
                                            synopsis: synopsis,
                                            context: context,
                                            homeScreenBloc: HomeScreenBloc(),
                                            seriesThumbnailUrls: seriesThumbnailUrls,
                                            nameOfSeries: nameOfSeries,
                                            rating: rating,
                                            numberOfSeason: numberOfSeason,
                                            numberOfViews: numberOfViews,
                                            genre: allGenreList,
                                            seriesId: seriesId);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    );
                  }
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
