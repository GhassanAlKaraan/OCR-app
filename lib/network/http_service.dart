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


// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;

// class MyHttpService {
//   final String apiKey = "K89408679188957";
//   final String ocrUri = "https://api.ocr.space/parse/image";

//   Future<String> analyzeImage(File file) async {
//     // Read the file as bytes
//     // List<int> imageBytes = await file.readAsBytes();

//     // Convert bytes to base64 string
//     // String base64Image = base64Encode(imageBytes);

//     // Create request body with base64 encoded file
//     // var reqBody = {
//     //   'language': 'ara',
//     //   'base64Image': base64Image,
//     // };

//         //! var bytes = file.readAsBytesSync();

//     //! var response = await http.post(
//     //!     Uri.parse(ocrUri),
//     //!     headers:{ "Content-Type":"multipart/form-data", 'apikey': apiKey } ,
//     //!     body: { "lang":"ara" , "file":bytes},
//     //!     encoding: Encoding.getByName("utf-8")
//     //! );

//     // Make POST request
//     // var response = await http.post(
//     //   Uri.parse(ocrUri),
//     //   headers: {'apikey': apiKey},
//     //   body: jsonEncode(reqBody),
//     // );

//     // Process response
//     //! var jsonResponse = jsonDecode(response.body);
//     //! print(jsonResponse);



//     //! if (response.statusCode == 200) {
//     //   if (jsonResponse.containsKey('ParsedResults') &&
//     //       jsonResponse['ParsedResults'] != null &&
//     //       jsonResponse['ParsedResults'].isNotEmpty) {
//     //     var generatedText = jsonResponse['ParsedResults'][0]['ParsedText'];
//     //     print(generatedText);
//     //     return generatedText;
//     //   } else {
//     //     print('ParsedResults not found in the response.');
//     //     return 'No Results: ParsedResults not found';
//     //   }
//     // } else {
//     //   print(response.reasonPhrase);
//     //   return 'No Results: Something went wrong';
//     // }
//   }
// }
