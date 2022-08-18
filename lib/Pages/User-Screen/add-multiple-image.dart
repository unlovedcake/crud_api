import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart' as dios;
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_inventory/Api-Response/api_response.dart';
import 'package:pos_inventory/Api-Service/user_service.dart';

import '../../constant.dart';

class AddMultipleImage extends StatefulWidget {
  const AddMultipleImage({Key? key}) : super(key: key);

  @override
  _AddMultipleImageState createState() => _AddMultipleImageState();
}

class _AddMultipleImageState extends State<AddMultipleImage> {
  final ImagePicker imagePicker = ImagePicker();

  String? fileName;
  List<XFile>? imageFileList = [];
  List<dynamic>? _documents = [];
  String path = "";

  var dio = dios.Dio();

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }

    for (int i = 0; i < imageFileList!.length; i++) {
      path = imageFileList![i].path;
      _documents!.add(path.split('/').last);
    }

    setState(() {});
  }

  Future<void> uploadMultipleImage() async {
    var responses;

    for (var file in imageFileList!) {
      String fileName = file.path.split("/").last;

      var formData = dios.FormData.fromMap({
        'title': 'wendux',
        'path[]': [
          await dios.MultipartFile.fromFile(file.path, filename: fileName),
        ]
      });
      responses = await dio.post(multipleImageURL,
          data: formData,
          options: Options(headers: {
            HttpHeaders.acceptHeader: 'application/json',
          }));
    }
    //request.files.addAll(newList);
    Map<String, String> headers = {
      "Accept": "application/json",
    };

    if (responses.statusCode == 200) {
      setState(() {
        getStream();
      });
      print("Add Success");
    } else {
      print("Failed");
    }
  }

  List<dynamic> data = [];

  // _getAllImage() async {
  //   ApiResponse response = await getAllImages();
  //
  //   // _streamController.sink.add(dataModel);
  //   if (response.error == null) {
  //     setState(() {
  //       print("Display Success");
  //       data = response.getUsers;
  //
  //       //_streamController.sink.add(userPost!);
  //     });
  //   } else {
  //     print("POSTOTOSOSOS");
  //     // ScaffoldMessenger.of(context)
  //     //     .showSnackBar(SnackBar(content: Text('${response.error}')));
  //   }
  // }

  Stream<List<dynamic>> getStream() async* {
    ApiResponse response = await getAllImages();
    data = response.getUsers;
    //await Future.delayed(const Duration(seconds: 2));
    // if (response.error == null) {
    //   setState(() {
    //     print("Display Success");
    //
    //     data = response.getUsers;
    //   });
    // } else {
    //   print("POSTOTOSOSOS");
    //   // ScaffoldMessenger.of(context)
    //   //     .showSnackBar(SnackBar(content: Text('${response.error}')));
    // }

    yield data;
  }

  @override
  void initState() {
    getStream();
    super.initState();
    // // A Timer method that run every 3 seconds
    // Timer.periodic(Duration(seconds: 2), (timer) {
    //   getStream();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Image Picker Example"),
        ),
        body: Center(
          child: Column(
            children: [
              MaterialButton(
                  color: Colors.blue,
                  child: const Text("Pick Images from Gallery",
                      style:
                          TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    selectImages();
                  }),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                  color: Colors.blue,
                  child: const Text("Add",
                      style:
                          TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    uploadMultipleImage();

                    // addImage();
                  }),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    itemCount: imageFileList!.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      String? text;
                      final item = imageFileList![index].path;

                      return Dismissible(
                        key: Key(item),
                        direction: DismissDirection.vertical,
                        onDismissed: (direction) {
                          setState(() {
                            imageFileList?.removeAt(index);
                          });
                        },
                        child: Image.file(File(imageFileList![index].path),
                            fit: BoxFit.cover),
                      );
                    }),
              )),
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  child: StreamBuilder<List<dynamic>>(
                    stream: getStream(),
                    builder: (BuildContext context, AsyncSnapshot snapdata) {
                      if (snapdata.connectionState == ConnectionState.waiting) {
                        // Show Waiting Indicator
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapdata.connectionState == ConnectionState.active ||
                          snapdata.connectionState == ConnectionState.done) {
                        if (snapdata.hasError) {
                          // Connection Done But Error Occured
                          return const Center(child: Text("Error Occured"));
                        } else if (snapdata.hasData) {
                          // Connection Done and Data Received
                          return GridView.builder(
                              itemCount: data.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                              itemBuilder: (BuildContext context, int index) {
                                String? text;
                                final item = data[index]['path'];

                                return Dismissible(
                                  key: Key(item),
                                  direction: DismissDirection.vertical,
                                  onDismissed: (direction) {
                                    setState(() {
                                      data.removeAt(index);
                                    });
                                  },
                                  child: Image.network(
                                    '${data[index]['path']}',
                                  ),
                                );
                              });

                          // return ListView.builder(
                          //   itemCount: data.length,
                          //   itemBuilder: (context, index) {
                          //     return Container(
                          //       height: 300,
                          //       child: Column(
                          //         children: [
                          //           CircleAvatar(
                          //               child: Image.network(
                          //             '${data[index]['path']}',
                          //             width: 40,
                          //             height: 40,
                          //           )),
                          //           Text('Name is : ${data[index]['title']}'),
                          //         ],
                          //       ),
                          //     );
                          //   },
                          // );
                        }
                        // Empty Data/ No Data Received
                        return const Center(child: Text("No Data Received"));
                      }
                      return Center(child: Text(snapdata.connectionState.toString()));
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
