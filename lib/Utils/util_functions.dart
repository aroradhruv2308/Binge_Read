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
