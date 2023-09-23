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
    processedList.sort((a, b) {
      final aTime = a['total_views'];
      final bTime = b['total_views'];
      if (aTime == null && bTime == null) {
        return 0;
      } else if (aTime == null) {
        return 1;
      } else if (bTime == null) {
        return -1;
      }

      // Compare the non-null values.
      return aTime.compareTo(bTime);
    });
  } else if (category == "trending_count") {
    processedList.sort((a, b) {
      final aTime = a['trending_count'];
      final bTime = b['trending_count'];
      if (aTime == null && bTime == null) {
        return 0;
      } else if (aTime == null) {
        return 1;
      } else if (bTime == null) {
        return -1;
      }

      // Compare the non-null values.
      return aTime.compareTo(bTime);
    });
  } else if (category == "top_searches") {
    processedList.sort((a, b) {
      final aTime = a['top_searches_count'];
      final bTime = b['top_searches_count'];
      if (aTime == null && bTime == null) {
        return 0;
      } else if (aTime == null) {
        return 1;
      } else if (bTime == null) {
        return -1;
      }

      // Compare the non-null values.
      return aTime.compareTo(bTime);
    });
  } else if (category == "top_picks") {
    processedList.sort((a, b) {
      final aTime = a['rating'];
      final bTime = b['rating'];
      if (aTime == null && bTime == null) {
        return 0;
      } else if (aTime == null) {
        return 1;
      } else if (bTime == null) {
        return -1;
      }

      // Compare the non-null values.
      return aTime.compareTo(bTime);
    });
  } else if (category == "new_releases") {
    processedList.sort((a, b) {
      final aTime = a['last_updated_time'];
      final bTime = b['last_updated_time'];
      if (aTime == null && bTime == null) {
        return 0;
      } else if (aTime == null) {
        return 1;
      } else if (bTime == null) {
        return -1;
      }

      // Compare the non-null values.
      return aTime.compareTo(bTime);
    });
  }
  return processedList;
}

Future<List<dynamic>> getBookmarkData() async {
  List<dynamic> bookmarkData = [];

  // If user is logged in, Get Bookmark data from DB.
  if (Globals.isLogin) {
    bookmarkData = await getBookmarkDataFromDb(Globals.userEmail);
    return bookmarkData;
  }

  // If user is not logged in, Get Data from Hive.
  // bookmarkData = await Globals.userAppDataService.getBookmarkDataFromHive();
  return bookmarkData;
}

void toggleBookmark(bool isBookmarked, dynamic id) async {
  // user will be logged in state
  if (!isBookmarked) {
    //update database
    addBookmarkItemToFirestore(id);

    //add in local storage
    Globals.bookmarkSeriesList.add(id);
  } else {
    //update database
    deleteBookmarkItemFromFirestore(id);

    //remove from local storage
    Globals.bookmarkSeriesList.remove(id);
  }
}
