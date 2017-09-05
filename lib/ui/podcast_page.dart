import 'package:flutter/material.dart';

import '../podcast.dart';
import '../podcast_provider.dart';
import '../podcast_utils.dart';

class PodcastPage extends StatefulWidget {
  final PodcastKey podcastKey;
  PodcastPage(this.podcastKey);
  @override
  _PodcastPageState createState() => new _PodcastPageState(podcastKey);
}

class _PodcastPageState extends State<PodcastPage> {
  final PodcastKey podcastKey;
  Podcast podcast;
  _PodcastPageState(this.podcastKey);

  initPodcast() async {
    var t = await PodcastProvider.get(podcastKey.getRssUrl());
    setState(() {
      this.podcast = t;
    });
  }

  @override
  Widget build(BuildContext context) {
    var bodyChild;
    if (podcast == null) {
      initPodcast();
      bodyChild = new Text("Loading");
    } else {
      var children = [
        new Hero(tag: podcastKey.key, child: new Image.network(podcast.image)),
        new Text(podcast.description)
      ];
      children.addAll(
          podcast.episodes.map((e) => new ListTile(title: new Text(e.title))));
      bodyChild = new ListView(children: children);
    }
    return new Scaffold(
        appBar: new AppBar(title: new Text(podcast?.title ?? "Loading")),
        body: new Container(
            padding: const EdgeInsets.all(16.0),
            child: bodyChild
        )
    );
  }
}
