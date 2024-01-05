// Importing necessary Dart and Flutter packages
import 'package:flutter/material.dart';
// Importing the main application widget
import 'app.dart';

// Entry point of the application
void main() async {
  // Ensure that the Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Run the application using the MainApp widget as the root widget
  runApp(const MainApp());
}
