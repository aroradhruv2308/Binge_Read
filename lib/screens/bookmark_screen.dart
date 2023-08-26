import 'package:binge_read/Utils/util_functions.dart';
import 'package:binge_read/db/appDto.dart';
import 'package:binge_read/models/models.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BookmarkPage extends StatefulWidget {
  List<BookmarkItems> bookmarkItems;
  BookmarkPage({super.key, required this.bookmarkItems});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: getBookmarkData(),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Container(
              padding: EdgeInsets.all(20),
              color: Colors.blue,
              child: Text(
                "No data",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      );
    });
  }
}
