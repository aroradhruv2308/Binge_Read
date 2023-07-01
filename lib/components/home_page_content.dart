// ignore_for_file: must_be_immutable

import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/bloc/home_screen_bloc/home_screen_bloc.dart';
import 'package:binge_read/db/query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home_page_books_data.dart';

class HomePageContent extends StatefulWidget {
  HomeScreenBloc homeScreenBloc = HomeScreenBloc();
  HomePageContent({super.key, homeScreenBloc});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  List<dynamic> seriesData = [];
  List<dynamic> mostViewedData = [];
  List<dynamic> trendingData = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
      child: FutureBuilder(
        future: getAllSeries(),
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
              seriesData.add(doc.data());
            }

            // Sorting seriesData w.r.t total_views which will be used to display most
            // viewed series.
            mostViewedData = [...seriesData];
            mostViewedData.sort((a, b) => a['total_views'].compareTo(b['total_views']));

            // Again sorting seriesData w.r.t trending_count to handle Trending
            // section data.
            trendingData = [...seriesData];
            trendingData.sort((a, b) => a['trending_count'].compareTo(b['trending_count']));

            // Use the retrieved data to build the content of the bottom sheet
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Trending",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lexend',
                      fontSize: 18 * MediaQuery.of(context).textScaleFactor,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  seriesCarousel(homeScreenBloc: widget.homeScreenBloc, context: context, seriesDataList: trendingData),
                  const SizedBox(height: 30),
                  Text(
                    "Most Viewed",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lexend',
                      fontSize: 18 * MediaQuery.of(context).textScaleFactor,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  seriesCarousel(
                      homeScreenBloc: widget.homeScreenBloc, context: context, seriesDataList: mostViewedData),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
