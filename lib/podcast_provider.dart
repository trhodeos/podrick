import 'dart:async';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart' as xml;
import 'podcast.dart';
import 'podcast_feed_reader.dart';

class _LocalPodcastCache {

  static Future<PodcastChannel> get(String rssUrl) async {
    return null;
  }

  static store(String rssUrl, PodcastChannel podcast) async {
    return null;
  }
}

Future<PodcastChannel> _downloadChannel(String url) async {
  var httpClient = createHttpClient();
  var response = await httpClient.read(url);
  var channel = createPodcastChannel(url, xml.parse(response));
  return channel;
}

class PodcastProvider {
  static Future<PodcastChannel> get(String rssUrl) async {
      print("Getting podcast $rssUrl from cache..");
      var podcast = await _LocalPodcastCache.get(rssUrl);
      if (podcast == null) {
        podcast = await _downloadChannel(rssUrl);
        _LocalPodcastCache.store(rssUrl, podcast);
      }
      return podcast;
    }
}


