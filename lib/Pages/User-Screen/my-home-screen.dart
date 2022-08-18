import 'package:pos_inventory/Pages/User-Screen/user-signin.dart';
import 'package:pos_inventory/Pages/User-Screen/user-signup.dart';
import 'package:pos_inventory/Routes/routes.dart';
import 'package:pos_inventory/Widget/elevated-button.dart';
import 'package:pos_inventory/Widget/sizebox.dart';

import 'package:flutter/material.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //remove arrow back icon
        centerTitle: true,
        title: Text(
          "Sittler App",
          style: _textTheme.headline4?.copyWith(
              fontSize: 20,
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "images/sittler-logo.jpg",
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.fill,
                ),
                addVerticalSpace(50),
                ElevatedButtonStyle.elevatedButton("Log In", onPressed: () {
                  NavigateRoute.gotoPage(context, const UserClientLoginPage());
                }),
                addVerticalSpace(20),
                ElevatedButtonStyle.elevatedButton("Register As Client", onPressed: () {
                  print("OK");

                  NavigateRoute.gotoPage(context, const UserClientRegisterPage());
                }),
                addVerticalSpace(20),
                ElevatedButtonStyle.elevatedButton("Register As Staff", onPressed: () {
                  print("OK");
                  //Navigator.pushNamed(context, '/user-service-login-page');
                  //NavigateRoute.gotoPage(context, const StaffSignUp());
                }),
                addVerticalSpace(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
