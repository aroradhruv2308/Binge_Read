import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerCarousel() {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: 4,
    itemBuilder: (BuildContext context, int index) {
      return Container(
        margin: EdgeInsets.all(8.0),
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      );
    },
  );
}
