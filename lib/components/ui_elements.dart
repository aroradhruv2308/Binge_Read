import 'dart:ui';

import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/bloc/book_detail_screen_bloc/bloc/book_detail_screen_bloc.dart';
import 'package:binge_read/db/appDto.dart';
import 'package:binge_read/db/query.dart';
import 'package:binge_read/screens/episode_reader_screen.dart';
import 'package:blur/blur.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:readmore/readmore.dart';
// ignore: depend_on_referenced_packages
import 'package:cached_network_image/cached_network_image.dart';

Widget seriesCard({
  required BuildContext context,
  String imageUrl = "",
  String seriesName = "",
  double rating = 0.0,
  int numberSeason = 0,
}) {
  return Container(
    padding: const EdgeInsets.only(right: 16),
    width: MediaQuery.of(context).size.width * 0.4,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: double.infinity,
              fit: BoxFit.fill,
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          seriesName,
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontFamily: "Lexend",
            overflow: TextOverflow.ellipsis,
            fontSize: SizeConstants.fourteenPixel,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Seasons: $numberSeason",
              style: const TextStyle(
                color: AppColors.greyColor,
                fontFamily: "Lexend",
                overflow: TextOverflow.ellipsis,
                fontSize: SizeConstants.fourteenPixel,
              ),
            ),
            Row(
              children: [
                Text(
                  "$rating",
                  style: const TextStyle(
                    color: AppColors.greyColor,
                    fontFamily: "Lexend",
                    overflow: TextOverflow.ellipsis,
                    fontSize: SizeConstants.fourteenPixel,
                  ),
                ),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget expandableText({String text = "Data has'nt arrived yet", double textHeight = 20}) {
  return ReadMoreText(
    text,
    trimLines: (textHeight / 12).floor(),
    style: const TextStyle(
      color: AppColors.greyColor,
      fontSize: SizeConstants.twelvePixel,
      fontFamily: "Lexend",
    ),
    trimMode: TrimMode.Line,
    trimCollapsedText: 'Show more',
    trimExpandedText: ' Show less',
    delimiterStyle: const TextStyle(color: AppColors.glowGreen),
    colorClickableText: AppColors.glowGreen,
  );
}

class SeasonDropdown extends StatefulWidget {
  final int numberOfSeasons;
  BookDetailScreenBloc delailScreenBloc = BookDetailScreenBloc();

  SeasonDropdown({super.key, required this.numberOfSeasons, required this.delailScreenBloc});

  @override
  _SeasonDropdownState createState() => _SeasonDropdownState();
}

class _SeasonDropdownState extends State<SeasonDropdown> {
  String selectedSeason = ''; // Initial selected season

  @override
  void initState() {
    super.initState();
    if (widget.numberOfSeasons > 0) {
      selectedSeason = 'Season 1'; // Set the initial selected season
    }
  }

  int? selectedValue = 1;
  @override
  Widget build(BuildContext context) {
    List<int> seasons = List.generate(widget.numberOfSeasons, (index) => index + 1);
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: const Row(
          children: [
            SizedBox(
              width: 3,
            ),
            Expanded(
              child: Text(
                'Season 1',
                style: TextStyle(
                  fontSize: SizeConstants.fourteenPixel,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lexend',
                  color: AppColors.whiteColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: seasons
            .map((item) => DropdownMenuItem<int>(
                  value: item,
                  child: Text(
                    "Season: $item",
                    style: const TextStyle(
                      fontSize: SizeConstants.twelvePixel,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "Lexend",
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          widget.delailScreenBloc.add(ShowSeasonEpisodesEvent(seasonNumber: value));
          setState(() {
            selectedValue = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 40,
          width: 140,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: AppColors.glowGreen,
            ),
            color: AppColors.backgroundColor,
          ),
          elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.whiteColor),
          iconSize: 18,
          iconEnabledColor: AppColors.whiteColor,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 200,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColors.backgroundColor,
            ),
            elevation: 4,
            offset: const Offset(-30, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            )),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}

Widget episodeCard({
  required BuildContext context,
  required List<Episode> episodes,
  required int seriesId,
  required String episodeName,
  required int episodeNumber,
  required String episodeSummary,
  required String episodeUrl,
}) {
  return InkWell(
    onTap: () {
      // here we will open the episode screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReaderScreen(
            url: episodeUrl,
            episodeNumber: episodeNumber,
            episodes: episodes,
          ),
        ),
      );
    },
    child: Card(
      color: AppColors.navBarColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Episode $episodeNumber",
                  style: const TextStyle(
                    fontSize: SizeConstants.twelvePixel,
                    fontFamily: "Lexend",
                    color: AppColors.greyColor,
                  ),
                ),
                const Text(
                  "1.3 mins",
                  style: TextStyle(
                    fontSize: SizeConstants.twelvePixel,
                    fontFamily: "Lexend",
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                episodeName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: SizeConstants.fourteenPixel,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Lexend",
                  color: AppColors.whiteColor,
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget customListTile({int id = 1}) {
  return FutureBuilder<Map<String, dynamic>?>(
    future: fetchSeriesDataById(id), // Specify the future to monitor
    builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // While the future is loading
        return Container();
      } else if (snapshot.hasError) {
        // If there was an error
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      } else {
        // When the future completes successfully
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          color: AppColors.navBarColor,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Flexible(
                  flex: 2,
                  child: Container(
                    width: 60,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.greyColor,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(snapshot.data?['Thumbnail URL']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        snapshot.data?['series_name'],
                        style: const TextStyle(
                            fontSize: SizeConstants.fourteenPixel,
                            fontFamily: 'Lexend',
                            color: AppColors.whiteColor,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Row(
                              children: [
                                Text(
                                  "${snapshot.data?['rating']}",
                                  style: const TextStyle(
                                      color: AppColors.greyColor,
                                      fontFamily: "Lexend",
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: SizeConstants.fourteenPixel),
                                ),
                                const SizedBox(
                                  width: 4,
                                  height: 8,
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Text(
                              "Seasons: ${snapshot.data?['number_of_seasons']}",
                              style: const TextStyle(
                                  fontSize: SizeConstants.fourteenPixel,
                                  fontFamily: 'Lexend',
                                  color: AppColors.greyColor,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    },
  );
}

Widget buildListView(List<dynamic> ids) {
  if (ids.length == 0) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        "Found No List Yet",
        style: TextStyle(
          color: AppColors.greyColor,
          fontFamily: 'Lexend',
          fontSize: SizeConstants.fourteenPixel,
        ),
      ),
    );
  }
  return ListView.builder(
    shrinkWrap: true,
    itemCount: ids.length,
    itemBuilder: (BuildContext context, int index) {
      int id = ids[index];
      return customListTile(id: id);
    },
  );
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey // Adjust the color of the dashed line as needed
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.square;

    const dashWidth = 5;
    const dashSpace = 5;
    var startY = 0.0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class EpisodePercentIndicatorIcon extends StatelessWidget {
  final int pctRead;

  const EpisodePercentIndicatorIcon({
    super.key,
    required this.pctRead,
  });

  @override
  Widget build(BuildContext context) {
    // If percentage read is 0 then show book menu icon.
    // if (pctRead == 0) {
    //   return Container(
    //     padding: const EdgeInsets.all(8),
    //     decoration: const BoxDecoration(
    //       shape: BoxShape.circle,
    //       color: AppColors.navBarColor,
    //     ),
    //     child: const Icon(
    //       Icons.menu_book_rounded,
    //       color: AppColors.whiteColor,
    //     ),
    //   );
    // }

    // If percentage read is 100, show done_rounded button.
    if (pctRead == 100) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.navBarColor,
        ),
        child: const Icon(
          Icons.done_rounded,
          color: AppColors.whiteColor,
        ),
      );
    }

    // Otherwise return Icon showing percentage in circle using
    // CircularPercentIndicator.
    return CircularPercentIndicator(
      radius: 20.0,
      lineWidth: 3.0,
      percent: pctRead / 100,
      center: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: pctRead.toString(),
              style: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 10.0,
                fontFamily: "Lexend",
              ),
            ),
            const TextSpan(
              text: "%",
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 7.0,
                fontFamily: "Lexend",
              ),
            ),
          ],
        ),
      ),
      progressColor: AppColors.greyColor,
      backgroundColor: AppColors.darkGreyColor,
      animation: true,
    );
  }
}
