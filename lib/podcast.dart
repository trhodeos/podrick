class PodcastEpisode {
  final String title;
  final String description;
  final String guid;
  final String url;
  final String type;
  PodcastEpisode(this.title, this.description, this.guid, this.url, this.type);

  @override
  String toString() {
    return "$title [$url, $type]: $description";
  }
}

class Podcast {
  final String title;
  final String rssUrl;
  final String description;
  final String image;
  final Iterable<PodcastEpisode> episodes;
  Podcast(this.title, this.rssUrl, this.description, this.image, this.episodes);

  @override
  String toString() {
    return "$title [$rssUrl]: (${episodes.length} episodes)";
  }
}
