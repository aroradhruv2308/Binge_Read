import 'package:binge_read/Utils/constants.dart';
import 'package:binge_read/Utils/global_variables.dart';
import 'package:binge_read/db/query.dart';
import 'package:binge_read/models/models.dart';

String capitalizeWords(String input) {
  if (input.isEmpty) {
    return input;
  }

  // Split the input string into individual words
  List<String> words = input.split(' ');

  // Capitalize the first letter of each word
  words = words.map((word) {
    final capitalizedWord = word[0].toUpperCase() + word.substring(1);
    return capitalizedWord;
  }).toList();

  // Join the capitalized words back into a single string
  final capitalizedString = words.join(' ');

  return capitalizedString;
}

List<dynamic> getCategoryList(String category, List<dynamic> series) {
  List<dynamic> processedList = List.from(series);
  if (category == "most_viewed") {
    processedList.sort((b, a) => a['total_views'].compareTo(b['total_views']));
  } else if (category == "trending_count") {
    processedList.sort((a, b) => a['trending_count'].compareTo(b['trending_count']));
  } else if (category == "top_searches") {
    processedList.sort((a, b) => a['top_searches_count'].compareTo(b['top_searches_count']));
  } else if (category == "top_picks") {
    processedList.sort((b, a) => a['rating'].compareTo(b['rating']));
  } else if (category == "new_releases") {
    processedList.sort((a, b) => a['last_updated_time'].compareTo(b['last_updated_time']));
  }
  return processedList;
}

Future<List<Map<String, dynamic>>> getBookmarkData() async {
  List<Map<String, dynamic>> bookmarkData = [];

  // If user is logged in, Get Bookmark data from DB.
  if (Globals.isLogin) {
    bookmarkData = await getBookmarkDataFromDb(Globals.userEmail);
    return bookmarkData;
  }

  // If user is not logged in, Get Data from Hive.
  // bookmarkData = await Globals.userAppDataService.getBookmarkDataFromHive();
  return bookmarkData;
}

void toggleBookmark(bool isBookmarked, dynamic id, bool isEpisode) async {
  dynamic code = isEpisode ? EPISODE_CODE : SERIES_CODE;

  if (Globals.isLogin) {
    if (!isBookmarked) {
      await addBookmarkItemToFirestore({code: id}, Globals.userEmail);
    } else {
      await deleteBookmarkItemFromFirestore({code: id}, Globals.userEmail);
    }
  }
}
