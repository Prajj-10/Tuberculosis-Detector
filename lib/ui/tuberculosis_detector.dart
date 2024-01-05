// Importing necessary Dart and Flutter packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tb_detector/ui/tb_photo_view.dart';
import 'package:image/image.dart' as img;
// Importing custom classifier class
import '../classifier/classifier.dart';
// Importing custom color style
import '../color_style.dart';

// Constants for label and model file locations
const labelLocation = 'assets/tflite_model/labels.txt';
const modelName = 'tb_model.tflite';

// Widget class for the Tuberculosis Detector
class TuberculosisDetector extends StatefulWidget {
  const TuberculosisDetector({super.key});

  @override
  State<TuberculosisDetector> createState() => _TuberculosisDetectorState();
}

// Enumeration for the result status of the analysis
enum ResultStatus {
  notStarted,
  notFound,
  found,
}

// Private state class for TuberculosisDetector widget
class _TuberculosisDetectorState extends State<TuberculosisDetector> {
  late Classifier? _classifier;
  bool _isAnalyzing = false;
  final picker = ImagePicker();
  File? _selectedImageFile;

  // Result
  ResultStatus _resultStatus = ResultStatus.notStarted;
  String _tbLabel = ''; // Name of Error Message
  double _tbAccuracy = 0.0;

  @override
  void initState() {
    super.initState();
    _loadClassifier();
  }

  // Method to load the classifier with labels and model
  Future<void> _loadClassifier() async {
    debugPrint(
      'Start loading of Classifier with '
      'labels at $labelLocation, '
      'model at $modelName',
    );
    final classifier = await Classifier.loadWith(
      labelFileName: labelLocation,
      modelFileName: modelName,
    );
    _classifier = classifier;
  }

  // Main Application Builder
  @override
  Widget build(BuildContext context) {
    return Container(
      color: tbBackgroundColor,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(
            flex: 1,
          ),
          _buildTitle(),
          const SizedBox(height: 60),
          _buildPhotoView(),
          const SizedBox(height: 20),
          _buildResultView(),
          const SizedBox(
            height: 20,
          ),
          _buildPickPhotoButton(
            title: 'Take a photo',
            source: ImageSource.camera,
          ),
          const SizedBox(
            height: 20,
          ),
          _buildPickPhotoButton(
            title: 'Choose from gallery',
            source: ImageSource.gallery,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  // Method to build the photo view stack
  Widget _buildPhotoView() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        TbPhotoView(file: _selectedImageFile),
        _buildAnalyzingText(),
      ],
    );
  }

  // Method to build the analyzing text widget
  Widget _buildAnalyzingText() {
    if (!_isAnalyzing) {
      return const SizedBox.shrink();
    }
    return const Text('Analyzing...', style: tbAnalyzingTextStyle);
  }

  // Method to build the title widget
  Widget _buildTitle() {
    return const Text(
      'Tuberculosis Prediction Tool',
      style: tbTitleTextStyle,
      textAlign: TextAlign.center,
    );
  }

  // Method to build the pick photo button
  Widget _buildPickPhotoButton({
    required ImageSource source,
    required String title,
  }) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(36.0),
      color: tbColorDarkBlue,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width / 1.5,
          onPressed: () => _onPickPhoto(source),
          child: Text(title,
              style: const TextStyle(
                fontFamily: kButtonFont,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: tbColorBlackBlue,
              ))),
    );
  }

  // Method to set the analyzing flag
  void _setAnalyzing(bool flag) {
    setState(() {
      _isAnalyzing = flag;
    });
  }

  // Method called when a photo is picked
  void _onPickPhoto(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) {
      return;
    }

    final imageFile = File(pickedFile.path);
    setState(() {
      _selectedImageFile = imageFile;
    });

    _analyzeImage(imageFile);
  }

  // Method to analyze the picked image using the classifier
  void _analyzeImage(File image) {
    _setAnalyzing(true);

    // Decoding the image to read as bytes
    final imageInput = img.decodeImage(image.readAsBytesSync())!;

    // Using the predict function and storing in the result category
    final resultCategory = _classifier!.predict(imageInput);

    // If the predicted result is less than 80% it classifies as not found
    final result = resultCategory.score >= 0.8
        ? ResultStatus.found
        : ResultStatus.notFound;
    final tbLabel = resultCategory.label;
    final accuracy = resultCategory.score;

    _setAnalyzing(false);

    setState(() {
      _resultStatus = result;
      _tbLabel = tbLabel;
      _tbAccuracy = accuracy;
    });
  }

  // Method to build the result view
  Widget _buildResultView() {
    var title = '';

    if (_resultStatus == ResultStatus.notFound) {
      title = 'Failed to recognise';
    } else if (_resultStatus == ResultStatus.found) {
      title = _tbLabel;
    } else {
      title = '';
    }

    //
    var accuracyLabel = '';
    if (_resultStatus == ResultStatus.found) {
      accuracyLabel = 'Accuracy: ${(_tbAccuracy * 100).toStringAsFixed(2)}%';
    }

    return Column(
      children: [
        Text(title, style: tbResultTextStyle),
        const SizedBox(height: 10),
        Text(accuracyLabel, style: tbResultRatingTextStyle)
      ],
    );
  }
}
