// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/bloc/book_detail_screen_bloc/bloc/book_detail_screen_bloc.dart';
import 'package:binge_read/db/query.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

Widget seriesCard(
    {required BuildContext context,
    String imageUrl = "",
    String seriesName = "",
    double rating = 0.0,
    int numberSeason = 0}) {
  return Container(
    padding: const EdgeInsets.only(right: 16),
    width: MediaQuery.of(context).size.width * 0.4,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
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
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Seasons : $numberSeason",
              style: const TextStyle(
                  color: AppColors.greyColor, fontFamily: "Lexend", overflow: TextOverflow.ellipsis, fontSize: 14),
            ),
            Row(
              children: [
                Text(
                  "$rating",
                  style: const TextStyle(
                      color: AppColors.greyColor, fontFamily: "Lexend", overflow: TextOverflow.ellipsis, fontSize: 14),
                ),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ],
            ),
          ],
        )
      ],
    ),
  );
}

Widget expandableText({String text = "Data has'nt arrived yet", double textHeight = 20}) {
  return ReadMoreText(
    text,
    trimLines: (textHeight / 18).floor(), // Adjust the line height according to your font size
    style: GoogleFonts.lato(
      textStyle: const TextStyle(color: AppColors.greyColor, fontSize: 18),
    ),
    trimMode: TrimMode.Line,
    trimCollapsedText: 'Show more',
    trimExpandedText: ' Show less',
    moreStyle: const TextStyle(fontSize: 18, color: AppColors.glowGreen),
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
              width: 4,
            ),
            Expanded(
              child: Text(
                'Season 1',
                style: TextStyle(
                  fontSize: 14,
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
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

Widget episodeCard(
    {required int seriesId, required String episodeName, required int episodeNumber, required String episodeSummary}) {
  return InkWell(
    onDoubleTap: () async {
      await Globals.userAppDataService?.incrementReadCount(seriesId.toString());
    },
    child: ExpansionTile(
      backgroundColor: AppColors.navBarColor,
      collapsedBackgroundColor: AppColors.navBarColor,
      expandedAlignment: Alignment.topCenter,
      textColor: AppColors.glowGreen,
      collapsedIconColor: AppColors.greyColor,
      iconColor: AppColors.glowGreen,
      collapsedTextColor: AppColors.whiteColor,
      trailing: IconButton(
        iconSize: 16,
        icon: const Icon(Icons.arrow_forward_ios),
        onPressed: () {},
      ),
      childrenPadding: EdgeInsets.zero,
      title: Text(
        "Episode $episodeNumber : $episodeName",
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Lexend',
        ),
      ),
      children: <Widget>[
        ListTile(
          title: Text(
            episodeSummary,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(fontWeight: FontWeight.w100, color: AppColors.greyColor, fontFamily: 'Lexend'),
          ),
        )
      ],
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
                            fontSize: 14,
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
                                      fontSize: SizeConstants.sixteenPixel),
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
                                  fontSize: 14,
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
        style: TextStyle(color: AppColors.greyColor, fontFamily: 'Lexend', fontSize: 16),
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
