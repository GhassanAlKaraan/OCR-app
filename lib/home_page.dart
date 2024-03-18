import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr_app/result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      // _processImage();
    }
  }

  Future<void> _processImage() async {
    setState(() {
      _isLoading = true;
    });

    final inputImage = InputImage.fromFilePath(_imageFile!.path);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    String extractedText = recognizedText.text;

    setState(() {
      _isLoading = false;
    });
    // print(extractedText);

    if (context.mounted) {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(result: extractedText),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google MLKit Text Recognition'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoading
                ? const CircularProgressIndicator()
                : (_imageFile == null
                    ? const Text('Select an image to analyze')
                    : Image.file(_imageFile!)),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _isLoading ? null : _pickImage,
                child: const Text('Pick from Gallery')),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _isLoading || (_imageFile == null) ? null : _processImage,
                child: const Text('Process Text'))
          ],
        ),
      ),
    );
  }
}
