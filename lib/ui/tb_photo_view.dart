// Importing necessary Dart and Flutter packages
import 'dart:io';
import 'package:flutter/material.dart';
// Importing custom color style
import '../color_style.dart';

// Widget class for displaying a photo in a container
class TbPhotoView extends StatelessWidget {
  // File representing the image to be displayed
  final File? file;
  // Constructor for TbPhotoView widget
  const TbPhotoView({super.key, this.file});

  @override
  Widget build(BuildContext context) {
    // Container widget to hold the image or empty view
    return Container(
      width: 350,
      height: 350,
      color: Color(0xFF5FA8D3), // Set background color
      child: (file == null)
          ? _buildEmptyView() // Show empty view if no image file is provided
          : Image.file(file!, fit: BoxFit.cover), // Display image from file
    );
  }

  // Private method to build the empty view
  Widget _buildEmptyView() {
    return const Center(
        child: Text(
      'Load your image here', // Placeholder text for empty view
      style: tbAnalyzingTextStyle, // Apply custom text style
    ));
  }
}
