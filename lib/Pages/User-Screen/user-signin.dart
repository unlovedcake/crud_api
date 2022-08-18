import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_inventory/Api-Response/api_response.dart';
import 'package:pos_inventory/Api-Service/user_service.dart';
import 'package:pos_inventory/Model/user_model.dart';
import 'package:pos_inventory/Pages/User-Screen/user-signup.dart';
import 'package:pos_inventory/Routes/routes.dart';
import 'package:pos_inventory/Widget/elevated-button.dart';
import 'package:pos_inventory/Widget/progress-dialog.dart';
import 'package:pos_inventory/Widget/sizebox.dart';
import 'package:pos_inventory/Widget/textformfied.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';
import 'main-screen.dart';
import 'package:http/http.dart' as http;

class UserClientLoginPage extends StatefulWidget {
  const UserClientLoginPage({Key? key}) : super(key: key);

  @override
  _UserClientLoginPageState createState() => _UserClientLoginPageState();
}

class _UserClientLoginPageState extends State<UserClientLoginPage> {
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController _passwordText = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;

  ApiResponse apiResponse = ApiResponse();
  // void _login() async {
  //   final response = await http.post(Uri.parse(loginURL),
  //       headers: {'Accept': 'application/json'},
  //       body: {'email': _emailText.text, 'password': _passwordText.text});
  //
  //   if (response.statusCode == 200) {
  //     apiResponse.data = response.body;
  //     print(apiResponse.data);
  //     //_saveTokeAndId(response.body as User);
  //     print("zzz");
  //     print(jsonDecode(response.body)["token"]);
  //     print(jsonDecode(response.body.length.toString()));
  //
  //     NavigateRoute.gotoPage(context, const MainScreen());
  //   } else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Invalid Creds')));
  //   }
  // }
  void _login() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Authenticating, Please wait...",
          );
        });

    ApiResponse response = await login(
      _emailText.text.toString(),
      _passwordText.text.toString(),
    );

    if (response.error == null) {
      _saveTokeAndId(response.data as User);
      print("Success");
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('You are now logged in !!!')));
      //Fluttertoast.showToast(msg: "Account created successfully :) ");

      NavigateRoute.gotoPage(context, const MainScreen());
    } else {
      print("Error Server");
      //setState(() {});

      Navigator.pop(context);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // Save Token and ID
  void _saveTokeAndId(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Log In"),
          ),
          body: SingleChildScrollView(
            reverse: true,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 3 / 2,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/sittler-logo.jpg"),
                            fit: BoxFit.cover),
                        // boxShadow: <BoxShadow>[
                        //   BoxShadow(
                        //       color: Colors.black54,
                        //       blurRadius: 15.0,
                        //       offset: Offset(0.0, 0.75))
                        // ],
                        //color: Colors.white60,
                      ),
                    ),
                  ),
                  addVerticalSpace(20),
                  TextFormFields.textFormFields("Email", "Email", _emailText,
                      widget: null,
                      sufixIcon: null,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next, validator: (value) {
                    if (value!.isEmpty) {
                      return ("Email is required");
                    } else if (!value!.contains("@")) {
                      return ("Invalid Email Format");
                    }
                  }),
                  addVerticalSpace(20),
                  TextFormFields.textFormFields("Password", "Password", _passwordText,
                      widget: null,
                      sufixIcon: IconButton(
                        icon: Icon(
                          _isHidden ? Icons.visibility : Icons.visibility_off,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          // This is the trick

                          _isHidden = !_isHidden;

                          (context as Element).markNeedsBuild();
                        },
                      ),
                      obscureText: _isHidden,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done, validator: (value) {
                    if (value!.isEmpty) {
                      return ("Password is required ");
                    }
                  }),
                  addVerticalSpace(20),
                  ElevatedButtonStyle.elevatedButton("Login", onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                    }
                  }),

                  // ElevatedButton(
                  //     child: Text("Login "),
                  //     onPressed: () {
                  //       // Navigator.pushNamed(context, '/user-client-login-page');
                  //     }),
                  addVerticalSpace(20),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        NavigateRoute.gotoPage(context, const UserClientRegisterPage());
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    )
                  ]),
                  addVerticalSpace(20),
                ],
              ),
            ),
          )),
    );
  }
}
