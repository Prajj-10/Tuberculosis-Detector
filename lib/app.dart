// Importing necessary Dart and Flutter packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tb_detector/ui/tuberculosis_detector.dart';

// Main application class for Tuberculosis Detector
class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set preferred screen orientations to portrait mode
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    // Build and return the MaterialApp widget
    return MaterialApp(
      title: 'Tuberculosis Detector', // App title
      theme: ThemeData.dark(), // Dark theme for the app
      home:
          const TuberculosisDetector(), // Set the home screen to TuberculosisDetector widget
      debugShowCheckedModeBanner:
          false, // Hide the debug banner in release mode
    );
  }
}
