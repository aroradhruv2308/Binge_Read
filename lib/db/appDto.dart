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
