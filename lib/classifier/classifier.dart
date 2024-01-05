// Importing necessary Dart and Flutter packages
import 'dart:math';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';

// Importing custom classes
import 'classifier_category.dart';
import 'classifier_model.dart';

// Type definition for ClassifierLabels
typedef ClassifierLabels = List<String>;

// Class definition for the image classifier
class Classifier {
  final ClassifierLabels _labels;
  final ClassifierModel _model;

  // Private constructor for the Classifier class
  Classifier._({
    required ClassifierLabels labels,
    required ClassifierModel model,
  })  : _labels = labels,
        _model = model;

  // Factory method for loading a Classifier with specified label and model files
  static Future<Classifier?> loadWith({
    required String labelFileName,
    required String modelFileName,
  }) async {
    try {
      // Load labels and model
      final labels = await _loadLabels(labelFileName);
      final model = await _loadModel(modelFileName);
      return Classifier._(labels: labels, model: model);
    } catch (e) {
      // Handle errors during initialization
      debugPrint('Can\'t initialize Classifier: ${e.toString()}');
      if (e is Error) {
        debugPrintStack(stackTrace: e.stackTrace);
      }
      return null;
    }
  }

  // Method for making predictions on an input image
  ClassifierCategory predict(Image image) {
    // Log original image information
    debugPrint(
      'Image: ${image.width}x${image.height}, '
      'size: ${image.length} bytes',
    );
    // Load the image and convert it to TensorImage for TensorFlow Input
    final inputImage = _preProcessInput(image);

    // Log pre-processed image information
    debugPrint(
      'Pre-processed image: ${inputImage.width}x${inputImage.height}, '
      'size: ${inputImage.buffer.lengthInBytes} bytes',
    );

    // Define output buffer for inference results
    final outputBuffer = TensorBuffer.createFixedSize(
      _model.outputShape,
      _model.outputType,
    );

    // Run inference on the input image
    _model.interpreter.run(inputImage.buffer, outputBuffer.buffer);

    // Post-process the output buffer and get the top result
    final resultCategories = _postProcessOutput(outputBuffer);

    // Output Buffer
    debugPrint('OutputBuffer: ${outputBuffer.getDoubleList()}');
    final topResult = resultCategories.first;

    // Log top result information
    debugPrint('Top category: $topResult');

    return topResult;
  }

  // Load labels from a specified file
  static Future<ClassifierLabels> _loadLabels(String labelsFileName) async {
    // #1 Load raw labels
    final rawLabels = await FileUtil.loadLabels(labelsFileName);

    // #2 Extract labels from raw format
    final labels = rawLabels
        .map((label) => label.substring(label.indexOf(' ')).trim())
        .toList();

    debugPrint('Labels: $labels');
    return labels;
  }

  // Load the model from a specified file
  static Future<ClassifierModel> _loadModel(String modelFileName) async {
    // #1 Load interpreter from asset
    final interpreter = await Interpreter.fromAsset(modelFileName);

    // #2 Get input and output shapes from the interpreter
    final inputShape = interpreter.getInputTensor(0).shape;
    final outputShape = interpreter.getOutputTensor(0).shape;

    debugPrint('Input shape: $inputShape');
    debugPrint('Output shape: $outputShape');

    // #3 Get input and output types from the interpreter
    final inputType = interpreter.getInputTensor(0).type;
    final outputType = interpreter.getOutputTensor(0).type;

    debugPrint('Input type: $inputType');
    debugPrint('Output type: $outputType');

    return ClassifierModel(
      interpreter: interpreter,
      inputShape: inputShape,
      outputShape: outputShape,
      inputType: inputType,
      outputType: outputType,
    );
  }

  // Pre-process the input image for TensorFlow
  TensorImage _preProcessInput(Image image) {
    // #1 Create TensorImage and load the image
    final inputTensor = TensorImage(_model.inputType);
    inputTensor.loadImage(image);

    // #2 Determine minimum length for cropping
    final minLength = min(inputTensor.height, inputTensor.width);
    final cropOp = ResizeWithCropOrPadOp(minLength, minLength);

    // #3 Resize the image to match the model input shape
    final shapeLength = _model.inputShape[1];
    final resizeOp = ResizeOp(shapeLength, shapeLength, ResizeMethod.BILINEAR);

    // #4 Normalize the image
    final normalizeOp = NormalizeOp(127.5, 127.5);

    // #5 Build an image processor with the defined operations
    final imageProcessor = ImageProcessorBuilder()
        .add(cropOp)
        .add(resizeOp)
        .add(normalizeOp)
        .build();

    // #6 Process the input image
    imageProcessor.process(inputTensor);
    return inputTensor;
  }

  // Post-process the output buffer and get the result categories
  List<ClassifierCategory> _postProcessOutput(TensorBuffer outputBuffer) {
    // #1 Create a tensor processor for probabilities
    final probabilityProcessor = TensorProcessorBuilder().build();

    // #2 Process the output buffer using the probability processor
    probabilityProcessor.process(outputBuffer);

    // #3 Create a TensorLabel from the labels and output buffer
    final labelledResult = TensorLabel.fromList(_labels, outputBuffer);

    // #4 Create a list to store result categories
    final categoryList = <ClassifierCategory>[];
    labelledResult.getMapWithFloatValue().forEach((key, value) {
      final category = ClassifierCategory(key, value);
      categoryList.add(category);
      debugPrint('label: ${category.label}, score: ${category.score}');
    });

    // #5 Sort the category list based on scores in descending order
    categoryList.sort((a, b) => (b.score > a.score ? 1 : -1));

    return categoryList;
  }
}
