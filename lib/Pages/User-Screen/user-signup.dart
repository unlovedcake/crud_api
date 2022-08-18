import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pos_inventory/Api-Response/api_response.dart';
import 'package:pos_inventory/Api-Service/user_service.dart';
import 'package:pos_inventory/Model/user_model.dart';
import 'package:pos_inventory/Pages/User-Screen/main-screen.dart';
import 'package:pos_inventory/Routes/routes.dart';
import 'package:pos_inventory/Widget/elevated-button.dart';
import 'package:pos_inventory/Widget/progress-dialog.dart';
import 'package:pos_inventory/Widget/sizebox.dart';
import 'package:pos_inventory/Widget/textformfied.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserClientRegisterPage extends StatefulWidget {
  const UserClientRegisterPage({Key? key}) : super(key: key);

  @override
  _UserClientRegisterPageState createState() => _UserClientRegisterPageState();
}

class _UserClientRegisterPageState extends State<UserClientRegisterPage> {
  final TextEditingController _nameText = TextEditingController();
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController _addressText = TextEditingController();
  final TextEditingController _contactText = TextEditingController();
  final TextEditingController _passwordText = TextEditingController();
  final TextEditingController _confirmPasswordText = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isHidden = true;

  void _registerUser() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Authenticating, Please wait...",
          );
        });

    ApiResponse response = await register(
        _nameText.text,
        _emailText.text,
        _addressText.text,
        _contactText.text,
        _passwordText.text,
        _confirmPasswordText.text);
    if (response.error == null) {
      _saveTokeAndId(response.data as User);
      print("Success");
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Account created successfully')));
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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Register"),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                addVerticalSpace(20),
                TextFormFields.textFormFields("Name", "Full Name", _nameText,
                    widget: null,
                    sufixIcon: null,
                    obscureText: false,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next, validator: (value) {
                  if (value!.isEmpty) {
                    return ("Name is required ");
                  }
                }),
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
                TextFormFields.textFormFields("Address", "Address", _addressText,
                    widget: null,
                    sufixIcon: null,
                    obscureText: false,
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.next, validator: (value) {
                  if (value!.isEmpty) {
                    return ("Address is required ");
                  }
                }),
                addVerticalSpace(20),
                TextFormFields.textFormFields(
                    "Contact Number", "Contact Number", _contactText,
                    widget: null,
                    sufixIcon: null,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next, validator: (value) {
                  if (value!.isEmpty) {
                    return ("Contact is required ");
                  }
                }),
                addVerticalSpace(20),
                TextFormFields.textFormFields("Password", "Password", _passwordText,
                    widget: null,
                    sufixIcon: IconButton(
                      icon: Icon(_isHidden ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        // This is the trick

                        _isHidden = !_isHidden;

                        (context as Element).markNeedsBuild();
                      },
                    ),
                    obscureText: _isHidden,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next, validator: (value) {
                  if (value!.isEmpty) {
                    return ("Password is required for login");
                  }
                }),
                addVerticalSpace(20),
                TextFormFields.textFormFields(
                    "Confirm Password", "Confirm Password", _confirmPasswordText,
                    widget: null,
                    sufixIcon: IconButton(
                      icon: Icon(_isHidden ? Icons.visibility : Icons.visibility_off),
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
                    return ("Confirm Password is required");
                  } else if (_confirmPasswordText.text != _passwordText.text) {
                    return "Password don't match";
                  }
                  return null;
                }),
                addVerticalSpace(20),
                ElevatedButtonStyle.elevatedButton("Sign Up", onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _registerUser();
                  }
                  print("Success!!!");
                  // Navigator.pushNamed(context, '/user-client-login-page');
                }),
                addVerticalSpace(20),
              ],
            ),
          ),
        ));
  }
}
