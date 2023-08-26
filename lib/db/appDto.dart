import 'package:binge_read/bloc/book_detail_screen_bloc/bloc/book_detail_screen_bloc.dart';

class Episode {
  final String name;
  final int number;
  final String summary;
  final String htmlUrl;
  int pctRead;
  final String? episodeId;

  Episode({
    this.name = "Temporary Name",
    this.number = 2,
    this.summary = "temporary long text",
    this.htmlUrl = "here will be the url",
    this.pctRead = 0,
    this.episodeId = "",
  });
}

class BookmarkItems {
  bool isEpisode;
  final String seriesTitle, thumbnailUrl;
  final double rating;
  final int seriesViews;
  final List<String> genre;
  final int seriesId;
  final String synopsis;
  final String episodeHtmlUrl;
  final int episodeNumber;
  final int seasonNumber;
  final BookDetailScreenBloc detailScreenBloc;
  final List<Episode> episodes;
  BookmarkItems(
      {this.isEpisode = false,
      this.seriesTitle = "",
      this.thumbnailUrl = "",
      this.rating = 0,
      this.seriesViews = 0,
      required this.genre,
      this.seriesId = 0,
      this.synopsis = "",
      this.episodeHtmlUrl = "",
      this.episodeNumber = 0,
      this.seasonNumber = 0,
      required this.detailScreenBloc,
      required this.episodes});
}
