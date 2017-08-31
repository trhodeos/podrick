import 'package:xml/xml.dart';
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

class PodcastChannel {
  final String title;
  final String rssUrl;
  final String description;
  final String image;
  final Iterable<PodcastEpisode> episodes;
  PodcastChannel(this.title, this.rssUrl, this.description, this.image, this.episodes);

  factory PodcastChannel.fromDataSnapshot(dataSnapshot) {
    return new PodcastChannel(dataSnapshot.value['title'], _getRssUrl(dataSnapshot.key), dataSnapshot.value['description'], dataSnapshot.value['imageUrl'], new List());
  }

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

  dynamic toFirebaseData() {
    return {
      "title": title,
      "imageUrl": image,
      "rssUrl": rssUrl,
      "description": description,
    };
  }
}

PodcastEpisode _createEpisode(XmlElement node) {
  // required
  var title = node.findElements("title").single.text;
  var description = node.findElements("description").single.text;
  var enclosure = node.findElements("enclosure");
  var rssUrl;
  var rssType;
  if (enclosure.length > 0) {
    rssUrl = enclosure.first.getAttribute("url");
    rssType = enclosure.first.getAttribute("type");
  }

  // optional
  var guid = node.findElements("guid").single?.text;
  return new PodcastEpisode(title, description, guid, rssUrl, rssType);
}

PodcastChannel _createChannel(String rssUrl, XmlElement channel) {
  var title = channel.findElements("title").single.text;
  //var link = channel.findElements("link").single.text;
  var description = channel.findElements("description").single.text;
  var image = channel.findElements("image").single.findElements("url").single.text;
  var episodes = channel.findElements("item").where((n) => n is XmlElement).map(_createEpisode);
  return new PodcastChannel(title, rssUrl, description, image, episodes);
}

PodcastChannel createPodcastChannel(String rssUrl, XmlDocument xmlDocument) {
  var rssIterable = xmlDocument.findElements("rss");
  if (rssIterable.length != 1) {
    throw new Exception("Expected 1 rss item");
  }
  var rss = rssIterable.single;
  var channel = rss.findElements("channel").single;
  return _createChannel(rssUrl, channel);
}
