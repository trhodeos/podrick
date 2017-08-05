import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flup/flup_types.dart';
import 'package:flup/podcast_feed_reader.dart';
import 'package:xml/xml.dart' as xml;

class FlupApp extends StatefulWidget {
  @override
  _FlupAppState createState() => new _FlupAppState();
}

class _FlupAppState extends State<FlupApp> {
  FlupConfiguration _configuration = new FlupConfiguration(
      theme: FlupTheme.dark,
      debugShowGrid: false,
      debugShowSizes: false,
      debugShowBaselines: false,
      debugShowLayers: false,
      debugShowPointers: false,
      debugShowRainbow: false,
      showPerformanceOverlay: false,
      showSemanticsDebugger: false);

  @override
  void initState() {
    super.initState();
  }

  ThemeData get theme {
    switch (_configuration.theme) {
      case FlupTheme.light:
        return new ThemeData(
            brightness: Brightness.light, primarySwatch: Colors.blue);
      case FlupTheme.dark:
        return new ThemeData(
            brightness: Brightness.dark, primarySwatch: Colors.lightBlue);
    }
    assert(_configuration.theme != null);
    return null;
  }

  Route<Null> _getRoute(RouteSettings settings) {
    final List<String> path = settings.name.split('/');
    // Paths *must* start with a '/'.
    if (path[0] != '') {
      return null;
    }

    // Specific channel page.
    if (path[1].startsWith('channel:')) {
      // Don't support channel sub-pages yet.
      if (path.length != 2) {
        return null;
      }

      final String channel = path[1].substring(8);
      return new MaterialPageRoute<Null>(
          settings: settings,
          builder: (BuildContext context) {
            return new Scaffold(
                appBar: new AppBar(
                  title: new Text(channel),
                ),
                body: new Text(channel));
          });
    }
    // Other paths are defined in the routes table.
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flup',
      theme: theme,
      debugShowMaterialGrid: _configuration.debugShowGrid,
      showPerformanceOverlay: _configuration.showPerformanceOverlay,
      showSemanticsDebugger: _configuration.showSemanticsDebugger,
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new MyHomePage(title: 'Podcasts')
      },
      onGenerateRoute: _getRoute,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
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
        margin: const EdgeInsets.only(bottom: 10.0),
        child: new Row(children: <Widget>[
          new Image.network(_channel.image, fit: BoxFit.contain),
          new Text(_channel.title),
          new IconButton(
              icon: new Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.pushNamed(context, '/channel:${_channel.title}');
              })
        ]));
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
      padding: const EdgeInsets.all(10.0),
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

void main() {
  runApp(new FlupApp());
}
