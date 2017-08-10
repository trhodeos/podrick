import 'dart:async';

import 'package:flutter/services.dart';

import 'package:xml/xml.dart' as xml;

import 'podcast_feed_reader.dart';

final Map<String, PodcastChannel> channels = new Map<String, PodcastChannel>();
Future<PodcastChannel> _downloadChannel(String url) async {
  var httpClient = createHttpClient();
  var response = await httpClient.read(url);
  var channel = createPodcastChannel(xml.parse(response));
  channel.rssUrl = url;
  return channel;
}

Future<PodcastChannel> getChannel(String url) async {
  if (!channels.containsKey(url)) {
    channels[url] = await _downloadChannel(url);
  }
  return channels[url];
}

