import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/model/loginmodel.dart';
import 'package:flutter_app/ui/CarCrashForm.dart';
import 'package:flutter_app/ui/widgets/custom_shape.dart';
import 'package:flutter_app/ui/widgets/responsive_ui.dart';
import 'package:flutter_app/ui/widgets/textformfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();

  Future<void> _showStatusDialog(String title, String msg) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Platform.isAndroid?AlertDialog(
            title: Text(title,style:TextStyle(fontWeight:FontWeight.bold,fontFamily: "Nunito",fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize))),
            content: Text(msg,style:TextStyle(fontFamily: "Nunito",fontSize: _large ? kLargeFontSize-2 : (_medium ? kMediumFontSize-2 : kSmallFontSize-2))),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'OK',
                  style: TextStyle(color: Color(0xff0985ba),fontFamily: "Nunito",fontSize: _large ? kLargeFontSize-2 : (_medium ? kMediumFontSize-2 : kSmallFontSize-2)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ):CupertinoAlertDialog(
            title: Text(title,style:TextStyle(fontWeight:FontWeight.bold,fontFamily: "Nunito",fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize))),
            content: Text(msg,style:TextStyle(fontFamily: "Nunito",fontSize: _large ? kLargeFontSize-2 : (_medium ? kMediumFontSize-2 : kSmallFontSize-2))),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'OK',
                  style: TextStyle(color: Color(0xff0985ba),fontSize: _large ? kLargeFontSize-2 : (_medium ? kMediumFontSize-2 : kSmallFontSize-2)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<LoginModel> login(username, password) async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, isDismissible: false);
    await pr.show();

    final response = await http.post(
        'https://automover.beedevstaging.com/api/login',
        body: {'email': username, 'password': password});

    try {
      LoginModel loginrespdata = loginModelFromJson(response.body);

      if (loginrespdata.status == "success") {
        pr.hide();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('loggedIn', "true");
        prefs.setString('username', loginrespdata.username);
        print(response.body);
        //   prefs.setString('userid', );
        prefs.setString('token_security', loginrespdata.token);
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Login Successful')));

        Navigator.of(context)
            .pushNamedAndRemoveUntil(HOME, (Route<dynamic> route) => false);
      } else {
        pr.hide();
        // Scaffold
        //     .of(context)
        //     .showSnackBar(SnackBar(content: Text('Invalid Login')));
        _showStatusDialog("Couldn't Sign In", "Invalid Credentials");
      }
    } catch (e) {
      pr.hide();
      // Scaffold
      //     .of(context)
      //     .showSnackBar(SnackBar(content: Text('error'+e.toString())));
      _showStatusDialog("Error occured", e.toString());
    }
  }
  @override
  void initState() {
    print(_large);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Container(
        height: _height,
        width: _width,
        padding: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              clipShape(),
              welcomeTextRow(),
              signInTextRow(),
              form(),
              forgetPassTextRow(),
              SizedBox(height: _height / 25),
              button(),
              signUpTextRow(),
            ],
          ),
        ),
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
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
              top: _large
                  ? _height / 30
                  : (_medium ? _height / 25 : _height / 20)),
          child: Image.asset(
            'assets/img/logo.png',
            height: _height / 3.5,
            width: _width / 3.5,
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        children: <Widget>[
          Text(
            "Welcome",
            style: TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.bold,
              fontSize: _large ? 60 : (_medium ? 50 : 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "Sign in to your account",
            style: TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.w200,
              fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize)
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
        key: _key,
        child: Column(
          children: <Widget>[
            emailTextFormField(),
            SizedBox(height: _height / 40.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: emailController,
      icon: Icons.email,
      hint: "Email ID",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: passwordController,
      icon: Icons.lock,
      obscureText: true,
      hint: "Password",
    );
  }

  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
//          Text(
//            "Forgot your password?",
//            style: TextStyle(fontWeight: FontWeight.w400,fontSize: _large? 14: (_medium? 12: 10)),
//          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              print("Routing");
            },
            child: Text(
              "",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Color(0xff0985ba)),
            ),
          )
        ],
      ),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () async {
        if (emailController.text.toString().isEmpty) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Please enter a valid Email',style: TextStyle(fontSize: _large ? kLargeFontSize-2 : (_medium ? kMediumFontSize-2 : kSmallFontSize-2)),)));
        } else if (passwordController.text.toString().isEmpty) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Please enter a valid password',style: TextStyle(fontSize: _large ? kLargeFontSize-2 : (_medium ? kMediumFontSize-2 : kSmallFontSize-2)),)));
        } else {
          try {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              login(emailController.text.toString(),
              passwordController.text.toString());
            }
          } on SocketException catch (_) {
            _showStatusDialog("No Internet Connection", "Internet connection required");
          }
          
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: [Color(0xff0985ba), Color(0xff1a6ea8)],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('SIGN IN',
            style: TextStyle(fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize))),
      ),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize)),
          ),
          SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: () {
              passwordController.clear();
              emailController.clear();
              Navigator.of(context).pushNamed(SIGN_UP);
              print("Routing to Sign up screen");
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xff0985ba),
                  fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize)),
            ),
          )
        ],
      ),
    );
  }
}

//      if (response.body.length >= 200) {
//        pr.hide().then((isHidden) {
//          print(isHidden);
//        });//logic is not acceptable but leaving it fior now
//        LoginModel loginrespdata = loginModelFromJson(response.body);
//
//
//        if (loginrespdata.responsecode == "200") {
//
//
////        var fido = Data(
////          id: loginrespdata.data.id,
////          tokenSecurity: loginrespdata.data.tokenSecurity,
////          userName: loginrespdata.data.userName,
////          userEmail: loginrespdata.data.userEmail,
////          userPhoto: loginrespdata.data.userPhoto,
////          userGender: loginrespdata.data.userGender,
////          userAddress: loginrespdata.data.userAddress,
////          userMobile: loginrespdata.data.userMobile,
////          userDob: loginrespdata.data.userDob,
////
////        );
////        // List<Data> items = new List();
////        DatabaseHelper db = new DatabaseHelper();
////        await db.db;
////        await db.insertUser(fido);
//          SharedPreferences prefs = await SharedPreferences.getInstance();
//          prefs.setString('loggedIn', "true");
//          prefs.setString('userid', loginrespdata.data.id);
//          prefs.setString('token_security', loginrespdata.data.tokenSecurity);
//          prefs.setString('username', loginrespdata.data.username);
//          prefs.setString('useremail', loginrespdata.data.useremail);
//          prefs.setString('usercontact', loginrespdata.data.usercontact);
//          prefs.setString('useraddress', loginrespdata.data.useraddress);
//          prefs.setString('password', password);
////        final allRows = await db.user();
////        print('query all rows:');
////        allRows.forEach((row) => print(row.userEmail+row.userName));
//
////        Fluttertoast.showToast(
////            msg: "200 " + loginrespdata.message,
////            toastLength: Toast.LENGTH_SHORT,
////            gravity: ToastGravity.CENTER,
////
////            backgroundColor: Colors.blueAccent,
////            textColor: Colors.white,
////            fontSize: 16.0
////        );
//          Navigator.pop(context);
//          Navigator.pushAndRemoveUntil(
//            context,
//            MaterialPageRoute(builder: (context) => Home()),
//                (Route<dynamic> route) => false,
//          );
//        }
//
//        else {
//          Fluttertoast.showToast(
//              msg: response.body.toString(),
//              toastLength: Toast.LENGTH_SHORT,
//              gravity: ToastGravity.CENTER,
//
//              backgroundColor: Colors.blueAccent,
//              textColor: Colors.white,
//              fontSize: 16.0
//          );
//        }
//
//      }
//      else
//      {
//        pr.hide().then((isHidden) {
//          print(isHidden);
//        });
//        LoginIssueModel respissuedata = loginIssueModelFromJson(
//            response.body);
//        if(respissuedata.responsecode=="405")
//        {
//
//          Navigator.push(context, new MaterialPageRoute(builder: (context) => Otp(email: username,)));
//        }
//        else {
//
//          Fluttertoast.showToast(
//              msg:"Wrong Credentials",
//              //response code is 400
//              toastLength: Toast.LENGTH_SHORT,
//              gravity: ToastGravity.BOTTOM,
//
//              backgroundColor: Colors.blueAccent,
//              textColor: Colors.white,
//              fontSize: 16.0
//          );
//        }
////        Fluttertoast.showToast(
////            msg: respissuedata.message.toString(),
////            toastLength: Toast.LENGTH_SHORT,
////            gravity: ToastGravity.CENTER,
////
////            backgroundColor: Colors.blueAccent,
////            textColor: Colors.white,
////            fontSize: 16.0
////        );
//
//
//      }
