import 'dart:async';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart' as xml;
import 'package:firebase_database/firebase_database.dart';
import 'podcast_feed_reader.dart';
import 'dart:convert';

final podcastsRef =
FirebaseDatabase.instance.reference().child('podcasts');

Future<PodcastChannel> _downloadChannel(String url) async {
  var httpClient = createHttpClient();
  var response = await httpClient.read(url);
  var channel = createPodcastChannel(url, xml.parse(response));
  return channel;
}

Future<PodcastChannel> getChannel(String url) async {
  print("Getting podcast at $url");
  var podcastKey = BASE64.encode(UTF8.encode(url));
  var podcastRef = podcastsRef.child(podcastKey);
  var podcast = await podcastRef.once();
  if (podcast.value != null) {
    return new PodcastChannel.fromDataSnapshot(podcast);
  }

  var podcastChannel = await _downloadChannel(url);
  podcastRef.set(podcastChannel.toFirebaseData());
  return podcastChannel;
}

