import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'ui/podcast_page.dart';
import 'ui/configuration.dart';
import 'ui/home_page.dart';
import 'ui/settings_page.dart';
import 'podcast_utils.dart';

final Logger log = new Logger("PodrickMain");

final String podcastPrefix = '/podcast:';

class PodrickApp extends StatefulWidget {
  @override
  _PodrickAppState createState() => new _PodrickAppState();
}

class _PodrickAppState extends State<PodrickApp> {
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
    log.info("Routing request ${settings.name}.");
    // Paths *must* start with a '/'.
    if (settings.name[0] != '/') {
      return null;
    }

    // Specific channel page.
    if (settings.name.startsWith(podcastPrefix)) {

      final String podcastKeyString = settings.name.substring(podcastPrefix.length);
      final PodcastKey podcastKey = new PodcastKey(podcastKeyString);
      log.info("Routing request for podcast ${podcastKey.key} -> ${podcastKey.getRssUrl()}.");
      return new MaterialPageRoute<Null>(
          settings: settings,
          builder: (BuildContext context) => new PodcastPage(podcastKey));
    } else {
      log.warning("Could not handle route ${settings.name}.");
    }
    // Other paths are defined in the routes table.
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Podrick',
      theme: theme,
      debugShowMaterialGrid: _configuration.debugShowGrid,
      showPerformanceOverlay: _configuration.showPerformanceOverlay,
      showSemanticsDebugger: _configuration.showSemanticsDebugger,
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new PodrickHomePage(title: 'Podrick'),
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

  log.info("Starting Podrick.");
  runApp(new PodrickApp());
}
