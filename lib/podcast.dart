import 'dart:convert';

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

  static String _getRssUrl(String key) {
    return UTF8.decode(BASE64.decode(key));
  }

  String getKey() {
    return BASE64.encode(UTF8.encode(rssUrl));
  }

  static String getKeyForUrl(String url) {
    return BASE64.encode(UTF8.encode(url));
  }
}
