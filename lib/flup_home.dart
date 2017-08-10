import 'dart:async';

import 'package:flutter/material.dart';
import 'channel_directory.dart';
import 'podcast_feed_reader.dart';
import 'itunes_podcast_searcher.dart';

class FlupHomePage extends StatefulWidget {
  FlupHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FlupHomePageState createState() => new _FlupHomePageState();
}

class TabChoice {
  final String title;
  final IconData icon;
  const TabChoice({this.title, this.icon});
}

const List<TabChoice> choices = const <TabChoice>[
  const TabChoice(title: "Library", icon: Icons.library_music),
  const TabChoice(title: "Find", icon: Icons.search)
];

final Image placeholder = new Image.network("placeholder");

class PodcastChannelWidget extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String rssUrl;

  PodcastChannelWidget({this.title, this.imageUrl="http://via.placeholder.com/100x100", this.rssUrl});

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 80.0,
        child: new InkWell(
          child: new Container(
              height: 56.0,
              child: new Row(children: [
                new Hero(tag: title, child: new Image.network(imageUrl, fit: BoxFit.contain)),
                new Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: new Text(title)),
              ])),
          onTap: () =>
              Navigator.pushNamed(context, '/channel:${Uri.encodeQueryComponent(rssUrl)}'),
        ));
  }
}


class LibraryWidget extends StatefulWidget {
  @override
  _LibraryWidgetState createState() => new _LibraryWidgetState();
}

class _LibraryWidgetState extends State<LibraryWidget> {
  @override
  Widget build(BuildContext context) {
    return new ListView(
      shrinkWrap: true,
      children: <Widget>[
        new PodcastChannelWidget(
          title: "Hidden Brain",
          rssUrl: "https://www.npr.org/rss/podcast.php?id=510308"),
        new PodcastChannelWidget(
          title: "Planet Money",
          rssUrl: "https://www.npr.org/rss/podcast.php?id=510289" /* planet money */),
        new PodcastChannelWidget(
          title: "Invisibilia",
          rssUrl: "https://www.npr.org/rss/podcast.php?id=510307" /* invisibilia */,
        )
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => new _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {

  SearchResults results;

  _updateSearch(s) async {
    var local = await queryItunes(s);
    setState(() {
      results = local;
    });
  }

  @override
  Widget build(BuildContext context) {
    var children =  <Widget> [
      new TextField(
        maxLines: 1,
        autocorrect: false,
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(icon: new Icon(Icons.search)),
        onChanged: (s) {
          _updateSearch(s);
        })
    ];

    if (results != null) {
      for (var result in results.results) {
        children.add(new PodcastChannelWidget(
          title: result.collectionName,
          imageUrl: result.getBestArtwork(),
          rssUrl: result.feedUrl
        ));
      }
    }

    return new Container(
        child: new ListView(
          children: children));
  }
}



class _FlupHomePageState extends State<FlupHomePage> {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
    length: choices.length,
    child: new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        bottom: new TabBar(
          isScrollable: false,
          tabs: choices.map((choice) {
            return new Tab(text: choice.title, icon: new Icon(choice.icon));
          }).toList(),
        )
      ),
      body: new TabBarView(
        children: choices.map((choice) {
          if (choice.title == "Library") {
            return new LibraryWidget();
          } else if (choice.title == "Find") {
            return new SearchWidget();
          }
        }).toList()
      )
    ));
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

  Future _downloadChannel() async {
    var c = await getChannel(rssUrl);
    setState(() => _channel = c);
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
                new Hero(tag: _channel.image, child: new Image.network(_channel.image, fit: BoxFit.contain)),
                new Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: new Text(_channel.title)),
              ])),
          onTap: () =>
              Navigator.pushNamed(context, '/channel:${Uri.encodeQueryComponent(_channel.rssUrl)}'),
        ));
  }
}

class PodcastGrid extends StatefulWidget {

  updateGrid(String s) {

  }
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
