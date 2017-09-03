import 'package:logging/logging.dart';
import 'package:xml/xml.dart';

import 'podcast.dart';

final Logger log = new Logger('feed_reader');

PodcastEpisode _decodeEpisode(XmlElement node) {
  // required
  var title = node.findElements("title").single.text;
  log.fine('Decoding episode $title.');

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

Podcast decodePodcast(String rssUrl, XmlDocument xmlDocument) {
  log.info('Decoding podcast at $rssUrl.');
  var rssIterable = xmlDocument.findElements("rss");
  if (rssIterable.length != 1) {
    throw new Exception("Expected 1 rss item");
  }
  var rss = rssIterable.single;
  var channel = rss.findElements("channel").single;
  var title = channel.findElements("title").single.text;
  var description = channel.findElements("description").single.text;
  var image = channel.findElements("image").single.findElements("url").single.text;
  var episodes = channel.findElements("item").where((n) => n is XmlElement).map(_decodeEpisode);
  return new Podcast(title, rssUrl, description, image, episodes);
}
