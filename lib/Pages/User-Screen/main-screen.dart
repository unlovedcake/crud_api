import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_inventory/Api-Response/api_response.dart';
import 'package:pos_inventory/Api-Service/api-service-provider.dart';
import 'package:pos_inventory/Api-Service/user_service.dart';
import 'package:pos_inventory/Model/post.dart';
import 'package:pos_inventory/Model/user_model.dart';
import 'package:pos_inventory/Pages/User-Screen/add-multiple-image.dart';
import 'package:pos_inventory/Pages/User-Screen/my-home-screen.dart';
import 'package:http/http.dart' as http;
import 'package:pos_inventory/Pages/User-Screen/post-screen.dart';
import 'package:pos_inventory/Routes/routes.dart';
import 'package:provider/src/provider.dart';
import '../../constant.dart';
import '../../utils.dart';
import 'list-of-users.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  User? user;
  Post? userPost;
  String nameUser = "";
  int idUser = 0;

  //create stream
  StreamController<Post> _streamController = StreamController();
  @override
  void dispose() {
    // stop streaming when app close
    _streamController.close();
  }

  // get user detail
  void getUser() async {
    ApiResponse response = await getCurrentUserLoggedInDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        nameUser = user!.name ?? '';
        idUser = user!.id ?? 0;
      });
    } else if (response.error == unauthorized) {
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  String body = "";
  List<dynamic> data = [];
  Stream<List<dynamic>> getStream() async* {
    ApiResponse response = await getUserPosts();
    data = response.getUsers;

    //await Future.delayed(const Duration(seconds: 2));

    yield data;
  }

  // get user detail
  // _getUserPost() async {
  //   ApiResponse response = await getUserPosts();
  //
  //   // _streamController.sink.add(dataModel);
  //   if (response.error == null) {
  //     setState(() {
  //       print("POSTOTOSOSOS");
  //
  //       data = response.getUsers;
  //
  //       //_streamController.sink.add(userPost!);
  //     });
  //   } else if (response.error == unauthorized) {
  //   } else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('${response.error}')));
  //   }
  // }

  // // a future method that fetch data from API

  // Future<void> getUserPost() async {
  //   final response = await http
  //       .get(Uri.parse(getUserAllPost), headers: {'Accept': 'application/json'});
  //
  //   if (response.statusCode == 200) {
  //     userPost = Post(
  //       id: int.parse(response.body[0]),
  //       userId: int.parse(response.body[1]),
  //       name: response.body[2],
  //       image: response.body[3],
  //       body: response.body[4],
  //     );
  //     _streamController.sink.add(userPost!);
  //     print(response.body[2]);
  //   } else {
  //     //print(response.body);
  //     throw Exception('Failed');
  //   }
  //
  //   //   final response = await http
  //   //       .get(Uri.parse(getUserAllPost), headers: {'Accept': 'application/json'});
  //   //   userPost = Post.fromJson(json.decode(response.body)['post']);
  //   //
  //   //   if (response.statusCode == 200) {
  //   //     // print(userPost!.name);
  //   //     _streamController.sink.add(userPost!);
  //   //   }
  //   //
  //   //   // var databody = json.decode(response.body)['post'];
  //   //   // Post dataModel = Post.fromJson(databody);
  //   //   // add API response to stream controller sink
  //   //   // userPost = response.data as Post?;
  //   //   // if (userPost == null) {
  //   //   //   return;
  //   //   // } else {
  //   //   //   _streamController.sink.add(userPost!);
  //   //   // }
  // }

  @override
  void initState() {
    super.initState();
    getUser();
    //getUserPost();
    //_getUserPost();

    // A Timer method that run every 3 seconds
    // Timer.periodic(Duration(seconds: 2), (timer) {
    //   getStream();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Blog App'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                NavigateRoute.gotoPage(context, const ListOfUsers());
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                NavigateRoute.gotoPage(context, const AddMultipleImage());
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                NavigateRoute.gotoPage(context, const PostScreen());
              },
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                logout().then((value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MyHomeScreen()),
                          (route) => false)
                    });
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              // Text(idUser.toString()),

              // Center(
              //   child: StreamBuilder<Post>(
              //     stream: _streamController.stream,
              //     builder: (context, snapdata) {
              //       switch (snapdata.connectionState) {
              //         case ConnectionState.waiting:
              //           return Center(
              //             child: CircularProgressIndicator(),
              //           );
              //         default:
              //           if (snapdata.hasError) {
              //             return Text('Please Wait....');
              //           } else {
              //             return BuildCoinWidget(snapdata.data!);
              //             // return ListView.builder(
              //             //   itemCount: data.length,
              //             //   itemBuilder: (context, index) {
              //             //     return Row(
              //             //       children: [Text('Name is : ${data[index]['name']}')],
              //             //     );
              //             //   },
              //             // );
              //           }
              //       }
              //     },
              //   ),
              // ),

              // Expanded(
              //   child: Container(
              //     color: Colors.grey,
              //     height: 150,
              //     child: ListView.builder(
              //         itemCount: data.length,
              //         itemBuilder: (context, index) {
              //           return Container(
              //             child: ListTile(
              //               title: Text(data[index]['name'].toString()),
              //               subtitle: Column(
              //                 children: [
              //                   Text(data[index]['body'].toString()),
              //                   //Text(data[index]['address'].toString()),
              //                 ],
              //               ),
              //               trailing: Container(
              //                 width: 100,
              //                 child: Row(
              //                   children: [
              //                     IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           );
              //         }),
              //   ),
              // )

              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  child: StreamBuilder<List<dynamic>>(
                    stream: context.watch<PostControllerProvider>().getStream(),
                    // stream: getStream(),
                    builder:
                        (BuildContext context, AsyncSnapshot<List<dynamic>> snapdata) {
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
                          return ListView.builder(
                            itemCount: snapdata.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                            child: Image.network(
                                          snapdata.data![index]['image'],
                                          width: 40,
                                          height: 40,
                                        )),
                                        Text("  " + snapdata.data![index]['name']),
                                      ],
                                    ),
                                    SizedBox(height: 12),

                                    Container(
                                        width: double.infinity,
                                        color: Colors.grey[200],
                                        child: Text(
                                            snapdata.data![index]['body'] == "Image Only"
                                                ? ""
                                                : snapdata.data![index]['body'])),

                                    Container(
                                        width: 100,
                                        height: snapdata.data![index]['imagePost'] == null
                                            ? 2
                                            : 40,
                                        child: snapdata.data![index]['imagePost'] == null
                                            ? null
                                            : Image.network(snapdata.data![index]
                                                    ['imagePost'] ??
                                                "")),

                                    Text(
                                      readTimestamp(snapdata.data![index]['timeStamp']),
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    //Text(readTimestamp(data[index]['timeStamp'])),
                                  ],
                                ),
                              );
                            },
                          );
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
        ),
      ),
    );
  }

  Widget BuildCoinWidget(Post dataModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Colors.grey[100],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network(
                  '${dataModel.image}',
                  width: 150,
                  height: 150,
                ),
              ],
            ),
          ),
          Text(
            '${dataModel.name}',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '\$${dataModel.body}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
