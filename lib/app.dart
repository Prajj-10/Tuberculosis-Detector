import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tb_detector/ui/tuberculosis_detector.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return MaterialApp(
      title: 'Tuberculosis Detector',
      theme: ThemeData.dark(),
      home: const TuberculosisDetector(),
      debugShowCheckedModeBanner: false,
    );
  }
}
