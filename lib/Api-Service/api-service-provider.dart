import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_inventory/Api-Response/api_response.dart';
import 'package:pos_inventory/Api-Service/user_service.dart';
import 'package:pos_inventory/Model/post.dart';
import 'package:pos_inventory/Model/user_model.dart';
import 'package:pos_inventory/Pages/User-Screen/main-screen.dart';
import 'package:dio/dio.dart' as dios;
import 'package:provider/src/provider.dart';

class PostControllerProvider with ChangeNotifier {
  var dio = dios.Dio();
  List<dynamic> data = [];
  List<dynamic> allUsers = [];
  User? user;
  Stream<List<dynamic>> getStream() async* {
    ApiResponse response = await getUserPosts();
    data = response.getUsers;

    await Future.delayed(const Duration(seconds: 2));

    yield data;
  }

  Stream<List<dynamic>> getAllUsers() async* {
    ApiResponse response = await getAllUserDetail();
    allUsers = response.getUsers;

    await Future.delayed(const Duration(seconds: 2));

    yield allUsers;
  }

  void userPost(String body, BuildContext context) async {
    ApiResponse response = await userPosts(
      body,
    );
    if (response.error == null) {
      print("Success");
      //Navigator.pop(context);
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Post created successfully')));
      //Fluttertoast.showToast(msg: "Post created successfully :) ");
      notifyListeners();
      //NavigateRoute.gotoPage(context, const MainScreen());
    } else {
      print("Error Server");
      //setState(() {});

      //Navigator.pop(context);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void userPostWithImage(
      List<XFile>? selectedImages, String bodyText, BuildContext context) async {
    ApiResponse response = await postWithImage(selectedImages, bodyText, context);
    if (response.error == null) {
      print("Success");
      Navigator.pop(context);
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Post created successfully')));
      Fluttertoast.showToast(msg: "Post created successfully :) ");
      notifyListeners();
      //NavigateRoute.gotoPage(context, const MainScreen());
    } else {
      print("Error Server");
      //setState(() {});

      //Navigator.pop(context);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

//   Future<void> postImage(
//       List<XFile>? selectedImages, String bodyText, BuildContext context) async {
//     var responses;
//
//     if (selectedImages == null) {
//       context.read<PostControllerProvider>().userPost(bodyText, context);
//     } else {
//       for (var file in selectedImages) {
//         String fileName = "";
//         fileName = file.path.split("/").last;
//
//         var formData = dios.FormData.fromMap({
//           'body': bodyText.isEmpty ? "Image Only" : bodyText,
//           'image': [
//             await dios.MultipartFile.fromFile(file.path, filename: fileName),
//           ]
//         });
//         // ApiResponse apiResponse = ApiResponse();
//         // apiResponse.data = formData.fields;
//         String token = await getToken();
//         print(file.path);
//         responses = await dio.post("http://localhost:8000/api/posts",
//             data: formData,
//             options: Options(headers: {
//               HttpHeaders.acceptHeader: 'application/json',
//               HttpHeaders.authorizationHeader: 'Bearer $token',
//             }));
//       }
//       if (responses.statusCode == 200) {
//         Navigator.pop(context);
//
//         Fluttertoast.showToast(msg: "Post created successfully :) ");
//         notifyListeners();
//         print("Add Success");
//       } else {
//         print("Failed");
//       }
//     }
//   }
}
