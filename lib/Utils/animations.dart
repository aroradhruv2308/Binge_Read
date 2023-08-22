import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerCarousel(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.15,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.all(8.0),
          width: 150.0,
          height: 100.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[700]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(4.0), // Reduced border radius
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget shimmerListPattern(BuildContext context) {
  return Column(
    children: List.generate(5, (index) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.0), // Space between circle and rectangle
            Expanded(
              child: Container(
                height: 60.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[800]!,
                  highlightColor: Colors.grey[700]!,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(4.0), // Reduced border radius
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }),
  );
}

Widget lottieLoader() {
  return Center(
    child: Lottie.asset(
      'lottie_animations/animation_loader.json',
      width: 100, // Adjust the width as needed
      height: 100, // Adjust the height as needed
    ),
  );
}
