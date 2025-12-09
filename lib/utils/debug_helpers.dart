import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DebugHelpers {
  // Wrap widgets with debug border to see their boundaries
  static Widget debugBorder(Widget child, {Color color = Colors.red}) {
    if (!kDebugMode) return child;
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1),
      ),
      child: child,
    );
  }
  
  // Add debug info overlay to any widget
  static Widget debugInfo(Widget child, String info) {
    if (!kDebugMode) return child;
    
    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            color: Colors.black54,
            child: Text(
              info,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  // Safe wrapper for potentially problematic layouts
  static Widget safeLayout({
    required Widget child,
    String? debugLabel,
    bool allowInfiniteWidth = false,
    bool allowInfiniteHeight = false,
  }) {
    Widget result = child;
    
    if (!allowInfiniteWidth || !allowInfiniteHeight) {
      result = LayoutBuilder(
        builder: (context, constraints) {
          // Check for infinite constraints
          if (!allowInfiniteWidth && constraints.maxWidth == double.infinity) {
            if (kDebugMode) {
              print('⚠️ Infinite width detected in ${debugLabel ?? 'widget'}');
            }
            result = SizedBox(
              width: MediaQuery.of(context).size.width,
              child: child,
            );
          }
          
          if (!allowInfiniteHeight && constraints.maxHeight == double.infinity) {
            if (kDebugMode) {
              print('⚠️ Infinite height detected in ${debugLabel ?? 'widget'}');
            }
            result = SizedBox(
              height: MediaQuery.of(context).size.height,
              child: result,
            );
          }
          
          return result;
        },
      );
    }
    
    return result;
  }
  
  // Log widget tree information
  static void logConstraints(BuildContext context, String widgetName) {
    if (!kDebugMode) return;
    
    final renderObject = context.findRenderObject();
    if (renderObject is RenderBox) {
      final constraints = renderObject.constraints;
      print('📏 $widgetName constraints: $constraints');
      print('📐 $widgetName size: ${renderObject.size}');
    }
  }
  
  // Check if widget has safe constraints
  static bool hasSafeConstraints(BoxConstraints constraints) {
    return constraints.maxWidth != double.infinity && 
           constraints.maxHeight != double.infinity;
  }
  
  // Measure widget build time
  static Widget measureBuildTime(Widget child, String widgetName) {
    if (!kDebugMode) return child;
    
    return Builder(
      builder: (context) {
        final stopwatch = Stopwatch()..start();
        final result = child;
        stopwatch.stop();
        
        if (stopwatch.elapsedMilliseconds > 16) { // More than one frame
          print('🐌 Slow build detected in $widgetName: ${stopwatch.elapsedMilliseconds}ms');
        }
        
        return result;
      },
    );
  }
  
  // Debug print with emoji categories
  static void debugLog(String message, {DebugLogType type = DebugLogType.info}) {
    if (!kDebugMode) return;
    
    String emoji;
    switch (type) {
      case DebugLogType.info:
        emoji = 'ℹ️';
        break;
      case DebugLogType.warning:
        emoji = '⚠️';
        break;
      case DebugLogType.error:
        emoji = '❌';
        break;
      case DebugLogType.success:
        emoji = '✅';
        break;
      case DebugLogType.navigation:
        emoji = '🧭';
        break;
      case DebugLogType.animation:
        emoji = '🎬';
        break;
    }
    
    debugPrint('$emoji $message');
  }
}

enum DebugLogType {
  info,
  warning,
  error,
  success,
  navigation,
  animation,
}

// Debug overlay widget for development
class DebugOverlay extends StatelessWidget {
  final Widget child;
  final bool showFPS;
  final bool showConstraints;
  
  const DebugOverlay({
    super.key,
    required this.child,
    this.showFPS = false,
    this.showConstraints = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return child;
    
    return Stack(
      children: [
        child,
        if (showFPS || showConstraints)
          Positioned(
            top: 50,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showFPS)
                    const Text(
                      'FPS: 60', // Placeholder - would need performance monitoring
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  if (showConstraints)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Text(
                          'W: ${constraints.maxWidth.toStringAsFixed(0)}\n'
                          'H: ${constraints.maxHeight.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}