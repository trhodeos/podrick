import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flup/podcast_feed_reader.dart';
import 'package:xml/xml.dart' as xml;

class FlupHomePage extends StatefulWidget {
  FlupHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FlupHomePageState createState() => new _FlupHomePageState();
}

class _FlupHomePageState extends State<FlupHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      drawer: new Drawer(
          child: new ListView(children: <Widget>[
        new DrawerHeader(child: new Text("Menu")),
        new ListTile(
            title: new Text("Podcasts"),
            onTap: () => Navigator.pushNamed(context, "/")),
        new ListTile(
            title: new Text("Settings"),
            onTap: () => Navigator.pushNamed(context, "/settings"))
      ])),
      body: new PodcastGrid(),
    );
  }
}

class PodcastChannelButton extends StatefulWidget {
  final rssUrl;

  PodcastChannelButton(this.rssUrl);

  @override
  _PodcastChannelButtonState createState() =>
      new _PodcastChannelButtonState(this.rssUrl);
}

class _PodcastChannelButtonState extends State<PodcastChannelButton> {
  final rssUrl;
  PodcastChannel _channel;

  _PodcastChannelButtonState(this.rssUrl) {
    _downloadChannel();
  }

  _downloadChannel() async {
    var httpClient = createHttpClient();
    var response = await httpClient.read(rssUrl);
    var channel = createPodcastChannel(xml.parse(response));
    setState(() {
      _channel = channel;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_channel == null) {
      return new Row(children: <Widget>[new Text("Loading...")]);
    }
    return new Container(
        height: 80.0,
        child: new InkWell(
          child: new Container(
              height: 56.0,
              child: new Row(children: [
                new Image.network(_channel.image, fit: BoxFit.contain),
                new Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: new Text(_channel.title)),
              ])),
          onTap: () =>
              Navigator.pushNamed(context, '/channel:${_channel.title}'),
        ));
  }
}

class PodcastGrid extends StatefulWidget {
  @override
  _PodcastGridState createState() => new _PodcastGridState();
}

class _PodcastGridState extends State<PodcastGrid> {
  @override
  Widget build(BuildContext context) {
    return new ListView(
      shrinkWrap: true,
      children: <Widget>[
        new PodcastChannelButton(
            "https://www.npr.org/rss/podcast.php?id=510308" /* hidden brain */),
        new PodcastChannelButton(
            "https://www.npr.org/rss/podcast.php?id=510289" /* planet money */),
        new PodcastChannelButton(
            "https://www.npr.org/rss/podcast.php?id=510307" /* invisibilia */)
      ],
    );
  }
}
