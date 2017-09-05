import 'dart:async';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:xml/xml.dart' as xml;

import 'feed_reader.dart';
import 'podcast.dart';

final Logger log = new Logger('podcast_provider');

class _LocalPodcastCache {
  static Map<String, Podcast> _localMap = new Map<String, Podcast>();

  static Future<Podcast> get(String rssUrl) async {
    return _localMap[rssUrl];
  }

  static store(String rssUrl, Podcast podcast) async {
    _localMap[rssUrl] = podcast;
  }
}

Future<Podcast> _downloadChannel(String url) async {
  var httpClient = createHttpClient();
  var response = await httpClient.read(url);
  var channel = decodePodcast(url, xml.parse(response));
  return channel;
}

class PodcastProvider {
  static Future<Podcast> get(String rssUrl) async {
      log.info("Getting podcast $rssUrl from cache..");
      var podcast = await _LocalPodcastCache.get(rssUrl);
      if (podcast == null) {
        log.info("Podcast $rssUrl not found in cache. Downloading.");
        podcast = await _downloadChannel(rssUrl);
        _LocalPodcastCache.store(rssUrl, podcast);
      }
      return podcast;
    }
}


