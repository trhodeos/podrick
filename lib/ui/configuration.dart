import 'package:flutter/foundation.dart';

enum PodrickTheme {
  light, dark
}

class PodrickConfiguration {
  PodrickConfiguration({
    @required this.theme,
    @required this.debugShowGrid,
    @required this.debugShowSizes,
    @required this.debugShowBaselines,
    @required this.debugShowLayers,
    @required this.debugShowPointers,
    @required this.debugShowRainbow,
    @required this.showPerformanceOverlay,
    @required this.showSemanticsDebugger
  }) :  assert(theme != null),
        assert(debugShowGrid != null),
        assert(debugShowSizes != null),
        assert(debugShowBaselines != null),
        assert(debugShowLayers != null),
        assert(debugShowPointers != null),
        assert(debugShowRainbow != null),
        assert(showPerformanceOverlay != null),
        assert(showSemanticsDebugger != null);
  final PodrickTheme theme;
  final bool debugShowGrid;
  final bool debugShowSizes;
  final bool debugShowBaselines;
  final bool debugShowLayers;
  final bool debugShowPointers;
  final bool debugShowRainbow;
  final bool showPerformanceOverlay;
  final bool showSemanticsDebugger;
}
