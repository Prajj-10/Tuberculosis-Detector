// Importing the necessary package for TensorFlow Lite in Flutter
import 'package:tflite_flutter/tflite_flutter.dart';

// Class definition for the classifier model
class ClassifierModel {
  // TensorFlow Lite interpreter for running inference
  Interpreter interpreter;

  // Shape of the input tensor (for example:  image dimensions)
  List<int> inputShape;

  // Shape of the output tensor (for example: classification results)
  List<int> outputShape;

  // Data type of the input tensor
  TfLiteType inputType;

  // Data type of the output tensor
  TfLiteType outputType;

  // Constructor for the ClassifierModel class
  ClassifierModel({
    required this.interpreter, // Required TensorFlow Lite interpreter
    required this.inputShape, // Required shape of the input tensor
    required this.outputShape, // Required shape of the output tensor
    required this.inputType, // Required data type of the input tensor
    required this.outputType, // Required data type of the output tensor
  });
}
