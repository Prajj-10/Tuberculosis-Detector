import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class UserInterface extends StatefulWidget {
  const UserInterface({super.key});

  @override
  State<UserInterface> createState() => _UserInterfaceState();
}

class _UserInterfaceState extends State<UserInterface> {
  Interpreter? _interpreter;
  File? _image;
  late List<int> _output;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/your_model.tflite');
      _output = List.filled(2, 0); // Assuming the output tensor has 2 elements
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  /*Future<void> runModel(File image) async {
    // Preprocess the image and prepare input tensor
    // TODO: Implement image preprocessing based on your model requirements
    // ...

    // Run inference
    try {
      await _interpreter!.run(
          inputTensors: {'input': inputTensor},
          outputTensors: {'output': _output});
    } catch (e) {
      print('Error running model: $e');
    }

    // Postprocess the output tensor
    // For a binary classification model, you can use a threshold to determine the class
    double confidenceThreshold = 0.5;
    String result = _output[1] > confidenceThreshold ? 'TB' : 'No TB';

    // Display the result
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Result'),
          content: Text('The model predicts: $result'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }*/

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Add your X-Ray Image',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
              onTap: _pickImage,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  width: size.width,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _image != null
                      ? Image.file(
                          _image!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.add_photo_alternate,
                          size: 100,
                          color: Colors.black87,
                        ),
                ),
              )),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                elevation: 4,
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ))
        ],
      ),
    );
  }
}
