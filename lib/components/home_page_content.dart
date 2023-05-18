import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent();

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  Future<String> fetchData() async {
    // Simulating a future data fetch
    await Future.delayed(Duration(seconds: 4));
    return "Data fetched!";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Shimmer.fromColors(
            baseColor: Color(0xFFE0E0E0),
            highlightColor: Color(0xFFF5F5F5),
            child: Container(
              width: double.infinity,
              height: 200.0,
              color: Colors.white,
            ),
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final data = snapshot.data;
          return Container();
        }
      },
    );
  }
}
