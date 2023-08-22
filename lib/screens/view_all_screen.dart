import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/Utils/util_functions.dart';
import 'package:binge_read/bloc/home_screen_bloc/home_screen_bloc.dart';
import 'package:binge_read/components/grid_view.dart';
import 'package:binge_read/components/home_page_books_data.dart';
import 'package:binge_read/db/query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewAllPage extends StatefulWidget {
  final String genre;
  ViewAllPage({super.key, required this.genre});

  @override
  State<ViewAllPage> createState() => _ViewAllPageState();
}

class _ViewAllPageState extends State<ViewAllPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.genre,
          style: const TextStyle(
            fontFamily: 'Lexend',
            fontSize: SizeConstants.eighteenPixel,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
            size: SizeConstants.eighteenPixel,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        future: getBooksForAGenre(widget.genre),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic> seriesData = [];
            List<QueryDocumentSnapshot<Map<String, dynamic>>>? documents = snapshot.data;
            for (QueryDocumentSnapshot<Map<String, dynamic>> doc in documents!) {
              seriesData.add(doc.data());
            }

            return SeriesGrid(
              context: context,
              homeScreenBloc: HomeScreenBloc(),
              seriesDataList: seriesData,
            );
          }
        },
      ),
    );
  }
}
