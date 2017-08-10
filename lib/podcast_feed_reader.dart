import 'package:xml/xml.dart';

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
  final String url;
  final String description;
  final String image;
  final Iterable<PodcastEpisode> episodes;
  String rssUrl;
  PodcastChannel(this.title, this.url, this.description, this.image, this.episodes);

  @override
  String toString() {
    return "$title [$url]: (${episodes.length} episodes)";
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

PodcastChannel _createChannel(XmlElement channel) {
  var title = channel.findElements("title").single.text;
  var link = channel.findElements("link").single.text;
  var description = channel.findElements("description").single.text;
  var image = channel.findElements("image").single.findElements("url").single.text;
  var episodes = channel.findElements("item").where((n) => n is XmlElement).map(_createEpisode);
  return new PodcastChannel(title, link, description, image, episodes);
}

PodcastChannel createPodcastChannel(XmlDocument xmlDocument) {
  var rssIterable = xmlDocument.findElements("rss");
  if (rssIterable.length != 1) {
    throw new Exception("Expected 1 rss item");
  }
  var rss = rssIterable.single;
  var channels = rss.findElements("channel");
  return channels.map(_createChannel).single;
}
