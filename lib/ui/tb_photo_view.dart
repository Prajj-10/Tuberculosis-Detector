import 'dart:io';
import 'package:flutter/material.dart';
import '../color_style.dart';

class TbPhotoView extends StatelessWidget {
  final File? file;
  const TbPhotoView({super.key, this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 350,
      color: Color(0xFF5FA8D3),
      child: (file == null)
          ? _buildEmptyView()
          : Image.file(file!, fit: BoxFit.cover),
    );
  }

  Widget _buildEmptyView() {
    return const Center(
        child: Text(
      'Load your image here',
      style: tbAnalyzingTextStyle,
    ));
  }
}
