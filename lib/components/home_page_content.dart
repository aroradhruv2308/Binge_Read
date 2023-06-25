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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
      child: FutureBuilder(
        future: getALLSeries(),
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
                  seriesCarousel(homeScreenBloc: widget.homeScreenBloc, context: context, seriesDataList: seriesData),
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
                  seriesCarousel(homeScreenBloc: widget.homeScreenBloc, context: context, seriesDataList: seriesData),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
