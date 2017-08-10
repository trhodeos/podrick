import 'dart:async';

import 'package:flutter/material.dart';

import 'flup_home.dart';
import 'flup_settings.dart';
import 'flup_types.dart';
import 'channel_page.dart';
import 'channel_directory.dart';

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

      final String channelName = Uri.decodeQueryComponent(path[1].substring(8));
      return new MaterialPageRoute<Null>(
          settings: settings,
          builder: (BuildContext context) => new ChannelPage(channelName));
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
        '/': (BuildContext context) => new FlupHomePage(title: 'Podcasts'),
        '/settings': (BuildContext context) => new FlupSettingsPage()
      },
      onGenerateRoute: _getRoute,
    );
  }
}

void main() {
  runApp(new FlupApp());
}
