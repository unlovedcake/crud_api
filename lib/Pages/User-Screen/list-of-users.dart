import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_inventory/Api-Service/api-service-provider.dart';
import 'package:pos_inventory/Routes/routes.dart';
import 'package:provider/src/provider.dart';

class ListOfUsers extends StatefulWidget {
  const ListOfUsers({Key? key}) : super(key: key);

  @override
  _ListOfUsersState createState() => _ListOfUsersState();
}

class _ListOfUsersState extends State<ListOfUsers> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Blog App'),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  child: StreamBuilder<List<dynamic>>(
                    stream: context.watch<PostControllerProvider>().getAllUsers(),
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
                                    Text(snapdata.data![index]['email']),
                                    Text(snapdata.data![index]['address']),
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
}
