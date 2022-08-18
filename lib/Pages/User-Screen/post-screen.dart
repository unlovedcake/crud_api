import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_inventory/Api-Response/api_response.dart';
import 'package:pos_inventory/Api-Service/api-service-provider.dart';
import 'package:pos_inventory/Api-Service/service.dart';
import 'package:pos_inventory/Api-Service/user_service.dart';
import 'package:pos_inventory/Routes/routes.dart';
import 'package:pos_inventory/Widget/elevated-button.dart';
import 'package:pos_inventory/Widget/progress-dialog.dart';
import 'package:pos_inventory/Widget/sizebox.dart';
import 'package:pos_inventory/Widget/textformfied.dart';
import 'package:provider/src/provider.dart';
import 'package:path/path.dart' as paths;
import 'package:dio/dio.dart' as dios;
import '../../constant.dart';
import 'main-screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _bodyText = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final ImagePicker imagePicker = ImagePicker();

  String fileNames = "";
  List<XFile>? imageFileList = [];
  List<dynamic>? _documents = [];
  String path = "";

  var dio = dios.Dio();

  PostService? service = PostService();

  File? imageFile;
  List<XFile>? selectedImages;

  String? fileName;
  var fileVideo;

  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;

  var formData;
  void _pickFiles() async {
    var response;
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        //allowedExtensions: ['jpg', 'pdf', 'doc', 'docx', 'png'],
      ))
          ?.files;

      String? _videoPost;

      print("ADASDASDd");
      print(_paths?.first.path);
      var filePath = _paths?.first.path;

      if (_fileName!.contains("mp4")) {
        formData = dios.FormData.fromMap({
          'body': "Hello",
          'video': [
            await dios.MultipartFile.fromFile(filePath!,
                //"data/user/0/com.posinventory.pos_inventory/cache/file_picker/received_1078947226051674.jpeg",
                filename: _fileName),
          ]
        });
      } else {
        formData = dios.FormData.fromMap({
          'body': "Hi",
          'image': [
            await dios.MultipartFile.fromFile(filePath!,
                //"data/user/0/com.posinventory.pos_inventory/cache/file_picker/received_1078947226051674.jpeg",
                filename: _fileName),
          ],
        });
      }

      String token = await getToken();

      response = await dio.post(userPostURL,
          data: formData,
          options: Options(headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));

      if (response.statusCode == 200) {
        print("OKE");
        setState(() {});
      } else {
        print("ERROR");
      }
    } on PlatformException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName = _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
  }

  void _upload(String inputSource) async {
    // Pick a video
    final ImagePicker _picker = ImagePicker();

    try {
      if (inputSource == "fileVideo") {
        fileVideo = await _picker.getVideo(source: ImageSource.gallery);

        fileName = paths.basename(fileVideo!.path);
        imageFile = File(fileVideo.path);
      } else {
        selectedImages = await imagePicker.pickMultiImage();
        if (selectedImages!.isNotEmpty) {
          imageFileList!.addAll(selectedImages!);
        }
      }
    } catch (e) {}

    setState(() {});
  }

  Future<void> uploadMultipleImage() async {
    var responses;

    if (selectedImages == null) {
      context.read<PostControllerProvider>().userPost(_bodyText.text, context);
    } else {
      for (var file in imageFileList!) {
        String fileName = "";
        fileName = file.path.split("/").last;

        var formData = dios.FormData.fromMap({
          'body': _bodyText.text,
          'image': [
            await dios.MultipartFile.fromFile(file.path, filename: fileName),
          ]
        });
        String token = await getToken();
        print(file.path);
        responses = await dio.post(userPostURL,
            data: formData,
            options: Options(headers: {
              HttpHeaders.acceptHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token',
            }));
      }
      if (responses.statusCode == 200) {
        print("Add Success");
      } else {
        print("Failed");
      }
    }
  }

  // Future<void> _upload(String inputSource) async {
  //   final picker = ImagePicker();
  //   PickedFile? pickedImage;
  //
  //   try {
  //     pickedImage = await picker.getImage(
  //         source: inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
  //         maxWidth: 1920);
  //
  //     setState(() {
  //       fileName = path.basename(pickedImage!.path);
  //       imageFile = File(pickedImage.path);
  //     });
  //   } catch (e) {}
  // }

  void _userPost() async {
    ApiResponse response = await userPosts(
      _bodyText.text,
    );
    if (response.error == null) {
      print("Success");
      //Navigator.pop(context);
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Post created successfully')));
      Fluttertoast.showToast(msg: "Post created successfully :) ");

      NavigateRoute.gotoPage(context, const MainScreen());
    } else {
      print("Error Server");
      //setState(() {});

      Navigator.pop(context);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: TextFormFields.textFormFields("Post", "Post", _bodyText,
                  widget: null,
                  sufixIcon: IconButton(
                      color: Colors.orange,
                      onPressed: () {
                        //selectImages();
                        _displayDialog(context);
                      },
                      icon: Icon(
                        Icons.add_box_rounded,
                        color: Colors.orange,
                      )),
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next, validator: (value) {
                if (value!.isEmpty) {
                  return ("Post is required");
                }
              }),
            ),
            addVerticalSpace(20),
            ElevatedButtonStyle.elevatedButton("Post", onPressed: () {
              context
                  .read<PostControllerProvider>()
                  .userPostWithImage(selectedImages, _bodyText.text, context);
              //uploadMultipleImage();
              // if (_formKey.currentState!.validate()) {
              //   context.read<PostControllerProvider>().userPost(_bodyText.text, context);
              //   //_userPost();
              // }
            }),
            ElevatedButton(
              onPressed: () => _pickFiles(),
              child: Text(_multiPick ? 'Pick files' : 'Pick file'),
            ),
          ],
        ),
      ),
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select a Photo From'),
            // content: TextField(
            //   controller: _textFieldController,
            //   textInputAction: TextInputAction.go,
            //   keyboardType: TextInputType.numberWithOptions(),
            //   decoration: InputDecoration(hintText: "Select a Photo From"),
            // ),
            actions: <Widget>[
              new OutlinedButton(
                child: new Text('Gallery'),
                onPressed: () {
                  _upload('Gallery');
                  Navigator.pop(context);
                },
              ),
              new OutlinedButton(
                child: new Text('Video'),
                onPressed: () {
                  _upload('fileVideo');
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
