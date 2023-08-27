import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/Utils/util_functions.dart';
import 'package:binge_read/components/bookmark_card.dart';
import 'package:binge_read/components/custom_appbar.dart';
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
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Bookmarked Elements",
            style: TextStyle(
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
        body: FutureBuilder<List<dynamic>>(
          future: getBookmarkData(),
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              logger.e(snapshot.data);
              return Column(
                children: List.generate(snapshot.data?.length ?? 0, (index) {
                  dynamic bookmarkItem = snapshot.data?[index];
                  bool isEpisode = false;
                  if (bookmarkItem[EPISODE_CODE] != null) {
                    isEpisode = true;
                  }
                  if (isEpisode) {
                  } else {}
                  return bookmarkCard();
                }),
              );
            }
          },
        ),
      );
    });
  }
}
