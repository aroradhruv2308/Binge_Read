import 'package:binge_read/Utils/animations.dart';
import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/Utils/util_functions.dart';
import 'package:binge_read/bloc/authentication_bloc/bloc/google_authentication_bloc.dart';
import 'package:binge_read/components/bookmark_card.dart';
import 'package:binge_read/components/custom_appbar.dart';
import 'package:binge_read/components/ui_elements.dart';
import 'package:binge_read/db/appDto.dart';
import 'package:binge_read/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_button/sign_in_button.dart';

// ignore: must_be_immutable
class BookmarkPage extends StatefulWidget {
  List<BookmarkItems> bookmarkItems;
  BookmarkPage({super.key, required this.bookmarkItems});
  late GoogleAuthenticationBloc googleAuthBloc;

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.googleAuthBloc = GoogleAuthenticationBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocBuilder<GoogleAuthenticationBloc, GoogleAuthenticationState>(
        bloc: widget.googleAuthBloc,
        builder: (context, state) {
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
            ),
            body: Globals.isLogin == true
                ? FutureBuilder<List<dynamic>>(
                    future: getBookmarkData(),
                    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No bookmarked items found.'));
                      } else {
                        List<dynamic>? seriesDataList = snapshot.data;
                        // Generate a list of cards from the snapshot data
                        return ListView.builder(
                          itemCount: seriesDataList?.length,
                          itemBuilder: (BuildContext context, int index) {
                            final data = seriesDataList?[index];
                            final name = data['series_name'];
                            final rating = data['rating'];
                            final thumbnailUrl = data['Thumbnail URL'];
                            final totalViews = data['total_views'];

                            return SeriesCard(
                              name: name,
                              rating: rating.toDouble(),
                              thumbnailUrl: thumbnailUrl,
                              totalViews: totalViews,
                            );
                          },
                        );
                      }
                    },
                  )
                : Column(
                    children: [
                      const SizedBox(
                        height: 40,
                        width: 40,
                      ),
                      lottieBookmarkScreenAnimation(),
                      const SizedBox(
                        height: 20,
                        width: 20,
                      ),
                      Container(
                        height: 120,
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: const Text(
                          '"Onboard to Unlock Your Bookmarks! Sign in to view your saved series and continue your watching journey."',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            letterSpacing: 1.5,
                            wordSpacing: 2,
                            color: AppColors.greyColor,
                            fontSize: 16,
                            fontFamily: 'lexend',
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10, width: 40),
                      SignInButton(
                        Buttons.google,
                        onPressed: () {
                          widget.googleAuthBloc.add(const SignInWithGoogleEvent());
                          if (state is GoogleAuthenticationFaliure) {
                            setState(() {});
                          }
                          if (state is GoogleAuthenticationLoading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (state is GoogleAuthenticationSuccess || Globals.isLogin == true) {
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
          );
        },
      );
    });
  }
}
