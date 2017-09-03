import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'ui/home_page.dart';
import 'ui/settings_page.dart';
import 'ui/configuration.dart';
import 'channel_page.dart';

class FlupApp extends StatefulWidget {
  @override
  _PodrickAppState createState() => new _PodrickAppState();
}

class _PodrickAppState extends State<FlupApp> {
  PodrickConfiguration _configuration = new PodrickConfiguration(
      theme: PodrickTheme.dark,
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
      case PodrickTheme.light:
        return new ThemeData(
            brightness: Brightness.light, primarySwatch: Colors.blue);
      case PodrickTheme.dark:
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
        '/': (BuildContext context) => new PodrickHomePage(title: 'Podcasts'),
        '/settings': (BuildContext context) => new PodrickSettingsPage()
      },
      onGenerateRoute: _getRoute,
    );
  }
}

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  runApp(new FlupApp());
}
