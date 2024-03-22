import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr_app/network/http_service.dart';
import 'package:ocr_app/pages/result_page.dart';

import '../utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;
  bool _isLoading = false;

  MyHttpService service = MyHttpService();

  Future<void> _takeImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _processImage() async {
    setState(() {
      _isLoading = true;
    });

    final inputImage = InputImage.fromFilePath(_imageFile!.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    //* String extractedText = recognizedText.text;

    String scannedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
    }
    setState(() {
      _isLoading = false;
    });
    await textRecognizer.close();
    if (context.mounted) {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(result: scannedText),
        ),
      );
    }
  }

  Future<void> _processArabicImage() async {
    setState(() {
      _isLoading = true;
    });
    final inputImage = _imageFile!;

    final generatedText = await service.analyzeImage(inputImage);

    setState(() {
      _isLoading = false;
    });

    if (context.mounted) {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(result: generatedText),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              utils.showInfoDialog(context, 'Developed by Ghass.dev');
            },
            icon: const Icon(Icons.info)),
        title: const Text('Text Recognition'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (_imageFile == null
                  ? const Text('Select an image to analyze')
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Stack(alignment: Alignment.center, children: [
                            Image.file(_imageFile!),
                            _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.black,
                                  )
                                : Container()
                          ]),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _imageFile = null;
                                });
                              },
                              child: const Text('Reset'))
                        ],
                      ),
                    )),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: _isLoading ? null : _pickImage,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.file_upload_sharp,
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Pick from Gallery'),
                        ],
                      )),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: _isLoading ? null : _takeImage,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text('Take Photo'),
                        ],
                      )),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GestureDetector(
                  onTap: () {
                    _isLoading || (_imageFile == null)
                        ? utils.showAlert(
                            context, "Please select an image first")
                        : _processImage();
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Colors.blue[800]!,
                          Colors.blue[800]!,
                          Colors.purple,
                          Colors.pink,
                        ])),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Google MLKit - English',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_ios,
                            color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GestureDetector(
                  onTap: () {
                    _isLoading || (_imageFile == null)
                        ? utils.showAlert(
                            context, "Please select an image first")
                        : _processArabicImage();
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Colors.orange[800]!,
                          Colors.orange[800]!,
                          // Colors.green,
                          Colors.cyan,
                        ])),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'OCR API - English + Arabic',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_ios,
                            color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
