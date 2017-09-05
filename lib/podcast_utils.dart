class PodcastKey {
  final String key;
  PodcastKey(this.key);
  factory PodcastKey.forRssUrl(String rssUrl) {
    return new PodcastKey(Uri.encodeQueryComponent(rssUrl));
  }

  String getRssUrl() {
    return Uri.decodeQueryComponent(key);
  }
}

