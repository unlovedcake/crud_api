// Register
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pos_inventory/Api-Response/api_response.dart';
import 'package:pos_inventory/Model/post.dart';
import 'package:pos_inventory/Model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../constant.dart';

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_inventory/Api-Response/api_response.dart';
import 'package:pos_inventory/Api-Service/user_service.dart';
import 'package:pos_inventory/Model/post.dart';
import 'package:pos_inventory/Pages/User-Screen/main-screen.dart';
import 'package:dio/dio.dart' as dios;
import 'package:provider/src/provider.dart';

import 'api-service-provider.dart';

Future<ApiResponse> register(String name, String email, String address, String contact,
    String password, String confirmpassword) async {
  ApiResponse apiResponse = ApiResponse();
  SharedPreferences pref = await SharedPreferences.getInstance();

  var dio = Dio();
  try {
    // Response response = await dio.post(
    //   registerURL,
    //   data: {
    //     'name': name,
    //     'email': email,
    //     'address': address,
    //     'contact': contact,
    //     'password': password,
    //     'password_confirmation': password
    //   },
    //   onSendProgress: (int sent, int total) {
    //     print("$sent $total");
    //   },
    //   options: Options(
    //       headers: {"accept": 'application/json'},
    //       followRedirects: false,
    //       validateStatus: (status) {
    //         return status! <= 500;
    //       }),
    // );
    final response = await http.post(Uri.parse(registerURL), headers: {
      'Accept': 'application/json'
    }, body: {
      'name': name,
      'email': email,
      'address': address,
      'contact': contact,
      'password': password,
      'password_confirmation': confirmpassword
    });

    switch (response.statusCode) {
      case 201:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        // var _token = jsonDecode(response.body)["user"]["id"];
        // await pref.setString(_token, 'token');
        print(jsonDecode(response.body)["user"]["id"]);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];

        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// login
Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(loginURL),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password});

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      // case 403:
      //   apiResponse.error = jsonDecode(response.body)['message'];

      // break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print("OKEKEKEKES");
    print(e.toString());

    apiResponse.error = serverError;
  }

  return apiResponse;
}

// Get All Users Info
Future<ApiResponse> getAllUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(getAllUsersURL),
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'});

    switch (response.statusCode) {
      case 200:
        apiResponse.getUsers = jsonDecode(response.body)['user'];
        print(apiResponse.data);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(apiResponse.getUsers);
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Get Logged In User
Future<ApiResponse> getCurrentUserLoggedInDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(userURL),
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'});

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Get  User Post
Future<ApiResponse> getUserPosts() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http
        .get(Uri.parse(getUserAllPostURL), headers: {'Accept': 'application/json'});

    switch (response.statusCode) {
      case 200:
        apiResponse.getUsers = jsonDecode(response.body)['post'];

        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e.toString());
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// get token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// get user id
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

//User Post

Future<ApiResponse> userPosts(String body) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();

    final response = await http.post(Uri.parse(userPostURL),
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
        body: {'body': body});

    switch (response.statusCode) {
      case 200:
        apiResponse.data = Post.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      // case 403:
      //   apiResponse.error = jsonDecode(response.body)['message'];

      // break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print("OKEKEKEKES");
    print(e.toString());

    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> postWithImage(
    List<XFile>? selectedImages, String bodyText, BuildContext context) async {
  var response;
  var formData;
  var dio = Dio();
  ApiResponse apiResponse = ApiResponse();

  if (selectedImages == null) {
    context.read<PostControllerProvider>().userPost(bodyText, context);
  } else {
    for (var file in selectedImages) {
      String fileName = "";
      fileName = file.path.split("/").last;

      formData = dios.FormData.fromMap({
        'body': bodyText.isEmpty ? "Image Only" : bodyText,
        'image': [
          await dios.MultipartFile.fromFile(file.path, filename: fileName),
        ]
      });

      String token = await getToken();
      print(file.path);
      response = await dio.post(userPostURL,
          data: formData,
          options: Options(headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
    }

    switch (response.statusCode) {
      case 200:
        apiResponse.data = formData.fields;

        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      // case 403:
      //   apiResponse.error = jsonDecode(response.body)['message'];

      // break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  return apiResponse;
}

// Get All Users Info
Future<ApiResponse> getAllImages() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response =
        await http.get(Uri.parse(getImagesURL), headers: {'Accept': 'application/json'});

    switch (response.statusCode) {
      case 200:
        apiResponse.getUsers = jsonDecode(response.body)['images'];
        Fluttertoast.showToast(msg: "Display All Images ");

        print("Display Success");
        break;

      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e.toString());
    apiResponse.error = serverError;
  }
  return apiResponse;
}
