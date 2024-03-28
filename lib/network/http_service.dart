// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class MyHttpService {

  // This is a free key, generate yourse here: https://ocr.space/OCRAPI
  final String apiKey = "K89408679188957";
  final String ocrUri = "https://api.ocr.space/parse/image";

  Future<String> analyzeImage(File file) async {
    var fileName = file.path.split('/').last;
    var request = http.MultipartRequest('POST', Uri.parse(ocrUri));

    var multipartFile = await http.MultipartFile.fromPath(
        'file', // Field name expected by the server
        file.path,
        contentType: MediaType('application', 'octet-stream'),
        filename: fileName);
    request.fields['language'] = 'ara';
    request.headers['apikey'] = apiKey;
    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      return jsonResponse['ParsedResults'][0]['ParsedText'];
    } else {
      throw Exception('Failed to load data');
    }
  }
}