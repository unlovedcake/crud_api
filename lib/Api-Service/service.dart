import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pos_inventory/Api-Service/user_service.dart';
import 'package:pos_inventory/constant.dart';

class PostService {
  Future<bool> addPost(Map<String, String> body, String filepath) async {
    String token = await getToken();

    Map<String, String> headers = {
      //'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest('POST', Uri.parse(userPostURL))
      ..fields.addAll(body)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    var response = await request.send();
    if (response.statusCode == 200) {
      print("OK");
      return true;
    } else {
      print("Error");
      return false;
    }
  }
}
