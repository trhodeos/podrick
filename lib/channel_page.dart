import 'package:flutter/material.dart';

import 'podcast_feed_reader.dart';

class ChannelPage extends StatelessWidget {
  final PodcastChannel channel;
  ChannelPage(this.channel);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(channel.title)),
        body: new Container(
            padding: const EdgeInsets.all(16.0),
            child: new ListView(
              children: <Widget>[
                new Hero(tag: channel.image, child: new Image.network(channel.image)),
                new Text(channel.description)
              ],
            )
        )
    );
  }
}
