import 'package:flutter/material.dart';

Widget bookmarkCard({String seriesName = "", double rating = 0.0, bool isEpisode = false, int numberOfViews = 0}) {
  return const Card(
    color: Colors.blue,
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        "Dhruv",
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
