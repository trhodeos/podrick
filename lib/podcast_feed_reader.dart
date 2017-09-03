import 'package:xml/xml.dart';
import 'podcast.dart';

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
