import 'package:binge_read/Utils/animations.dart';
import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/bloc/book_detail_screen_bloc/bloc/book_detail_screen_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:binge_read/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

Widget seriesCard(
    {required BuildContext context,
    String image_url = "",
    String series_name = "",
    double rating = 0.0,
    int number_season = 0}) {
  return Container(
    padding: EdgeInsets.only(right: 16),
    width: MediaQuery.of(context).size.width * 0.5,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Image.network(
                image_url,
                fit: BoxFit.fill,

                // Replace with your image URL
                // Adjust the image fit as per your need
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          series_name,
          style: const TextStyle(
              color: AppColors.whiteColor,
              fontFamily: "Lexend",
              overflow: TextOverflow.ellipsis,
              fontSize: SizeConstants.sixteenPixel),
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Seasons : $number_season",
              style: const TextStyle(
                  color: AppColors.greyColor,
                  fontFamily: "Lexend",
                  overflow: TextOverflow.ellipsis,
                  fontSize: SizeConstants.sixteenPixel),
            ),
            Row(
              children: [
                Text(
                  "$rating",
                  style: const TextStyle(
                      color: AppColors.greyColor,
                      fontFamily: "Lexend",
                      overflow: TextOverflow.ellipsis,
                      fontSize: SizeConstants.sixteenPixel),
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
      textStyle: TextStyle(color: AppColors.greyColor, fontSize: 18),
    ),
    trimMode: TrimMode.Line,
    trimCollapsedText: 'Show more',
    trimExpandedText: ' Show less',
    moreStyle: const TextStyle(fontSize: 18, color: AppColors.glowGreen),
    delimiterStyle: TextStyle(color: AppColors.glowGreen),
    colorClickableText: AppColors.glowGreen,
  );
}

class SeasonDropdown extends StatefulWidget {
  final int numberOfSeasons;
  BookDetailScreenBloc delailScreenBloc = BookDetailScreenBloc();

  SeasonDropdown({required this.numberOfSeasons, required this.delailScreenBloc});

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
            padding: EdgeInsets.all(8),
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

Widget episodeCard({required String episodeName, required int episodeNumber, required String episodeSummary}) {
  return ExpansionTile(
    backgroundColor: AppColors.navBarColor,
    collapsedBackgroundColor: AppColors.navBarColor,
    expandedAlignment: Alignment.topCenter,
    textColor: AppColors.glowGreen,
    collapsedIconColor: AppColors.greyColor,
    iconColor: AppColors.glowGreen,
    collapsedTextColor: AppColors.whiteColor,
    trailing: IconButton(
      iconSize: 16,
      icon: Icon(Icons.arrow_forward_ios),
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
          style: TextStyle(fontWeight: FontWeight.w100, color: AppColors.greyColor, fontFamily: 'Lexend'),
        ),
      )
    ],
  );
}
