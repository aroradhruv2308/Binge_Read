import 'package:binge_read/Utils/animations.dart';
import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/bloc/home_screen_bloc/home_screen_bloc.dart';
import 'package:binge_read/components/home_page_books_data.dart';
import 'package:binge_read/screens/view_all_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../db/query.dart';

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
          const SizedBox(
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
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
                      style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w300),
                      decoration: InputDecoration(
                        hintText: 'Search Your Series',
                        hintStyle: TextStyle(fontFamily: 'Lexend'),
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
                  return Center(child: lottieLoader()); // we be adding default loader
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
                                          fontSize: SizeConstants.eighteenPixel,
                                          color: AppColors.whiteColor,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ViewAllPage(
                                                      genre: genre,
                                                    )),
                                          ).then((value) => setState(() => {}));
                                        },
                                        child: const Text(
                                          'view-all',
                                          style: TextStyle(
                                              fontFamily: 'Lexend',
                                              fontSize: SizeConstants.twelvePixel,
                                              color: AppColors.greyColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                                    future: getBooksForAGenre(genre),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return shimmerCarousel(context);
                                      } else if (snapshot.hasError) {
                                        return Center(child: Text('Error: ${snapshot.error}'));
                                      } else {
                                        List<dynamic> seriesData = [];
                                        List<QueryDocumentSnapshot<Map<String, dynamic>>>? documents = snapshot.data;
                                        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documents!) {
                                          seriesData.add(doc.data());
                                        }

                                        return seriesCarousel(
                                          context: context,
                                          homeScreenBloc: HomeScreenBloc(),
                                          seriesDataList: seriesData,
                                        );
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
