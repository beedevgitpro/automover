import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/model/loginmodel.dart';
import 'package:flutter_app/ui/widgets/custom_shape.dart';
import 'package:flutter_app/ui/widgets/customappbar.dart';
import 'package:flutter_app/ui/widgets/responsive_ui.dart';
import 'package:flutter_app/ui/widgets/textformfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'widgets/custom_progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  bool isConnected = true;
  var subscription;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  FlutterToast flutterToast;

  @override
  void initState() {
    super.initState();
    flutterToast = FlutterToast(context);
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        if (result.toString() == "ConnectivityResult.none") {
          isConnected = false;
        } else {
          isConnected = true;
        }
      });
      // Got a new connectivity status!
      // print(result.toString());
      // print(isConnected);
    });
  }

  _showToast(var message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: kPrimaryColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12.0,
          ),
          Text(
            message,
            style: TextStyle(
                color: Colors.white,
                fontSize: _large
                    ? kLargeFontSize
                    : (_medium ? kMediumFontSize : kSmallFontSize)),
          ),
        ],
      ),
    );
    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 5),
    );
  }

  Future<LoginModel> SignUP(username, email, password, confirmpassword) async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, isDismissible: false);
    await pr.show();
    var url = Uri.parse('https://survey.automover.com.au/api/register');
    final response = await http.post(url, body: {
      'name': username,
      'email': email,
      'password': password,
      'c_password': confirmpassword
    });

    try {
      LoginModel singinrespdata = loginModelFromJson(response.body);
      //  print("signi" + singinrespdata.toString());
      if (singinrespdata.status == "success") {
        pr.hide();
        Navigator.of(context).pop();
        _showToast("User Registered Successfully");

//        SharedPreferences prefs = await SharedPreferences.getInstance();
//        prefs.setString('loggedIn', "true");
//        //   prefs.setString('userid', );
//        prefs.setString('token_security',singinrespdata.token);

      } else {
        pr.hide();
        _showToast(singinrespdata.status);
      }
    } catch (e) {
      pr.hide();
      _showStatusDialog("Email is Already Registered", null);
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
          key: _scaffoldKey,
          body: Builder(
            builder: (ctx) => Container(
              height: _height,
              width: _width,
              margin: EdgeInsets.only(bottom: 5),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      clipShape(),
                      registerTextRow(),
                      // createAccountTextRow(),
                      form(),
                      SizedBox(height: _height / 30),
                      button(ctx),
                      signInTextRow(),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Widget createAccountTextRow() {
    return Container(
      // margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Create an account",
            style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w200,
                fontSize: _large
                    ? kLargeFontSize
                    : (_medium ? kMediumFontSize : kSmallFontSize)),
          ),
        ],
      ),
    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 4
                  : (_medium ? _height / 3.75 : _height / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff0985ba), Color(0xff1a6ea8)],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 4.5
                  : (_medium ? _height / 4.25 : _height / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff0985ba), Color(0xff1a6ea8)],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          // margin: EdgeInsets.only(
          //     top: _large
          //         ? _height / 30
          //         : (_medium ? _height / 25 : _height / 20)),
          child: Image.asset(
            'assets/img/logo.png',
            height:
                _large ? _width / 3.2 : (_medium ? _width / 2.4 : _width / 1.7),
            width:
                _large ? _width / 3.0 : (_medium ? _width / 2.2 : _width / 1.5),
          ),
        ),
      ],
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 80.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large
                    ? kLargeFontSize
                    : (_medium ? kMediumFontSize : kSmallFontSize)),
          ),
          SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: () {
              passwordController.clear();
              emailController.clear();
              // Navigator.of(context).pushNamedAndRemoveUntil(SIGN_IN,(r)=>false);
              Navigator.pop(context);
            },
            child: Text(
              "Sign In",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xff0985ba),
                  fontSize: _large
                      ? kLargeFontSize
                      : (_medium ? kMediumFontSize : kSmallFontSize)),
            ),
          )
        ],
      ),
    );
  }

  Widget registerTextRow() {
    return Container(
      //margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Register",
            style: TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.bold,
              fontSize: _large ? 55 : (_medium ? 45 : 35),
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
      child: Form(
        child: Column(
          children: <Widget>[
            firstNameTextFormField(),
            SizedBox(height: _height / 45.0),
            emailTextFormField(),
            SizedBox(height: _height / 45.0),
            passwordTextFormField(),
            SizedBox(height: _height / 45.0),
            confirmpasswordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return CustomTextField(
      textEditingController: userNameController,
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "First Name",
    );
  }

  void _showStatusDialog(String title, String msg) {
    Alert(
      context: context,
      title: title,
      desc: msg,
      style: AlertStyle(
        titleStyle: TextStyle(
            fontSize: _large ? kLargeFontSize + 6 : kMediumFontSize + 4),
        descStyle: TextStyle(
            fontSize: _large ? kLargeFontSize + 2 : kMediumFontSize + 2),
        isOverlayTapDismiss: false,
        animationType: AnimationType.grow,
        isCloseButton: false,
      ),
      image: Image.asset(
        'assets/img/logo-new.png',
        width: _width * 0.60,
      ),
      buttons: [
        DialogButton(
          color: Color(0xff167db3),
          child: Text(
            'Close'.toUpperCase(),
            style: TextStyle(
                color: Colors.white,
                fontSize: _large ? kLargeFontSize : kMediumFontSize),
          ),
          onPressed: () {
            Navigator.pop(context);
            // jobRefNode.requestFocus();
          },
        )
      ],
    ).show();
  }

  Widget emailTextFormField() {
    return CustomTextField(
      textEditingController: emailController,
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
      hint: "Email ID",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: passwordController,
      obscureText: true,
      icon: Icons.lock,
      hint: "Password",
    );
  }

  Widget confirmpasswordTextFormField() {
    return CustomTextField(
      textEditingController: confirmpasswordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      icon: Icons.lock,
      hint: "Confirm Password",
    );
  }

  Widget button(BuildContext context) {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () async {
        FocusScope.of(context).requestFocus(new FocusNode());
        if (userNameController.text.toString().isEmpty) {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
            'Please Enter Your Name',
            style: TextStyle(
                fontSize: _large
                    ? kLargeFontSize
                    : (_medium ? kMediumFontSize : kSmallFontSize)),
          )));
          // _showStatusDialog("Name is required", "Please enter your Name");
        } else if (emailController.text.toString().isEmpty) {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
            'Please Enter a Valid Email',
            style: TextStyle(
                fontSize: _large
                    ? kLargeFontSize
                    : (_medium ? kMediumFontSize : kSmallFontSize)),
          )));
          // _showStatusDialog("Email is required", "Please enter your Email");
        } else if (!RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
            .hasMatch(emailController.text.toString())) {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
            'Please Enter a Valid Email',
            style: TextStyle(
                fontSize: _large
                    ? kLargeFontSize
                    : (_medium ? kMediumFontSize : kSmallFontSize)),
          )));
          // _showStatusDialog("Invalid Email", "Please enter a valid Email");
        } else if (passwordController.text.toString().isEmpty) {
          // Scaffold
          //     .of(context)
          //     .showSnackBar(SnackBar(content: Text('Please enter a valid password')));
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
            'Please Enter a Password',
            style: TextStyle(
                fontSize: _large
                    ? kLargeFontSize
                    : (_medium ? kMediumFontSize : kSmallFontSize)),
          )));
        } else if (confirmpasswordController.text.toString().isEmpty) {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
            'Please Confirm Entered Password',
            style: TextStyle(
                fontSize: _large
                    ? kLargeFontSize
                    : (_medium ? kMediumFontSize : kSmallFontSize)),
          )));
          // _showStatusDialog("Password confirmation is required", "Please enter a valid password");
        } else if (passwordController.text.toString() !=
            confirmpasswordController.text.toString()) {
          // Scaffold
          //     .of(context)
          //     .showSnackBar(SnackBar(content: Text('Passwords Don\'t Match')));
          _showStatusDialog(
              "'Password' and 'Confirm Password' must match", null);
        } else {
          isConnected
              ? SignUP(
                  userNameController.text.toString(),
                  emailController.text.toString(),
                  passwordController.text.toString(),
                  confirmpasswordController.text.toString())
              : _showStatusDialog(
                  "No Internet Connection", "Internet connection required");
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        height: _height / 15,
        width: _large ? _width / 2 : (_medium ? _width / 2.5 : _width / 2.25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Color(0xff0985ba), Color(0xff1a6ea8)],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'REGISTER',
          style: TextStyle(
              fontFamily: "Nunito",
              fontSize: _large
                  ? kLargeFontSize
                  : (_medium ? kMediumFontSize : kSmallFontSize)),
        ),
      ),
    );
  }
}
