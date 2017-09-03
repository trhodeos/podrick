import 'package:flutter/material.dart';

import '../podcast.dart';
import '../podcast_provider.dart';

class ChannelPage extends StatefulWidget {
  final String channelUrl;
  ChannelPage(this.channelUrl);
  @override
  _ChannelPageState createState() => new _ChannelPageState(channelUrl);
}

class _ChannelPageState extends State<ChannelPage> {
  final String channelUrl;
  Podcast channel;
  _ChannelPageState(this.channelUrl) {
    initChannel();
  }

  initChannel() async {
    var t = await PodcastProvider.get(channelUrl);
    setState(() {
      this.channel = t;
    });
  }

  @override
  Widget build(BuildContext context) {
    var bodyChild;
    if (channel == null) {
      bodyChild = new Text("Loading");
    } else {
      var children = [
        new Hero(tag: channel.title, child: new Image.network(channel.image)),
        new Text(channel.description)
      ];
      children.addAll(
          channel.episodes.map((e) => new ListTile(title: new Text(e.title))));
      bodyChild = new ListView(children: children);
    }
    return new Scaffold(
        appBar: new AppBar(title: new Text(channel?.title ?? "Loading")),
        body: new Container(
            padding: const EdgeInsets.all(16.0),
            child: bodyChild
        )
    );
  }
}
