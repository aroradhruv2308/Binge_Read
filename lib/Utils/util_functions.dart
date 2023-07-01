import 'package:binge_read/Utils/global_variables.dart';

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
  List<dynamic> processedList = [];
  if (category == "most_viewed") {
    processedList = series;
    processedList.sort((b, a) => a['total_views'].compareTo(b['total_views']));
  } else if (category == "trending_count") {
    processedList = series;
    processedList.sort((a, b) => a['trending_count'].compareTo(b['trending_count']));
  } else if (category == "top_searches") {
    processedList = series;
    processedList.sort((a, b) => a['top_searches_count'].compareTo(b['top_searches_count']));
  } else if (category == "top_picks") {
    logger.e(category);
    processedList = series;
    logger.d(series);
    processedList.sort((b, a) => a['rating'].compareTo(b['rating']));
    logger.e(processedList);
  } else if (category == "new_releases") {
    processedList = series;
    processedList.sort((a, b) => a['last_updated_time'].compareTo(b['last_updated_time']));
  }
  return processedList;
}
