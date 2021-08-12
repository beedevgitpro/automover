import 'dart:math';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/model/loginmodel.dart';
import 'package:flutter_app/ui/CarCrashForm.dart';
import 'package:flutter_app/ui/widgets/custom_shape.dart';
import 'package:flutter_app/ui/widgets/responsive_ui.dart';
import 'package:flutter_app/ui/widgets/textformfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:strings/strings.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'widgets/custom_progress_dialog.dart';
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
  bool isConnected = true;
  var subscription;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();

  void _showStatusDialog(String title, String msg, String btnText) {
    Alert(
      context: context,
      title: title,
      desc: msg,
      style: AlertStyle(
        isOverlayTapDismiss: false,
        animationType: AnimationType.grow,
        isCloseButton: false,
        titleStyle: TextStyle(
            fontSize: _large ? kLargeFontSize + 6 : kMediumFontSize + 4),
        descStyle: TextStyle(
            fontSize: _large ? kLargeFontSize + 2 : kMediumFontSize + 2),
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

  Future<LoginModel> login(username, password) async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, isDismissible: false);
    await pr.show();
    try {
      var url = Uri.parse('https://survey.automover.com.au/api/login');

      final response = await http.post(

          // 'https://autoaus.adtestbed.com/api/login',
          url,
          body: {'email': username, 'password': password});
      // print(response.body);
      LoginModel loginrespdata = loginModelFromJson(response.body);
      if (loginrespdata.status == "success") {
        await pr.hide();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('loggedIn', "true");
        prefs.setString('username', loginrespdata.username);
        prefs.setInt('id', loginrespdata.id);
        // print(response.body);
        //   prefs.setString('userid', );
        prefs.setString('token_security', loginrespdata.token);
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
          'Login Successful',
          style: TextStyle(
              color: Colors.white,
              fontSize: _large ? kLargeFontSize : kMediumFontSize),
        )));

        Navigator.of(context)
            .pushNamedAndRemoveUntil(HOME, (Route<dynamic> route) => false);
      } else {
        await pr.hide();
        // Scaffold
        //     .of(context)
        //     .showSnackBar(SnackBar(content: Text('Invalid Login')));
        _showStatusDialog("Email/Password is Incorrect", null, 'OK');
      }
    } catch (e) {
      await pr.hide();
      // Scaffold
      //     .of(context)
      //     .showSnackBar(SnackBar(content: Text('error'+e.toString())));
      _showStatusDialog("Email/Password is Incorrect", null, 'OK');
    }
  }

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: _height,
          width: _width,
          padding: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                clipShape(),
                welcomeTextRow(),
                //signInTextRow(),
                form(),
                forgetPassTextRow(),
                SizedBox(height: _height / 75),
                button(),
                signUpTextRow(),
              ],
            ),
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
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Container(
            alignment: Alignment.center,
            // margin: EdgeInsets.only(
            //     top: _large
            //         ? _height / 30
            //         : (_medium ? _height / 25 : _height / 20)),
            child: Image.asset(
              'assets/img/logo.png',
              height: _large
                  ? _width / 3.2
                  : (_medium ? _width / 2.4 : _width / 2.2),
              width: _large
                  ? _width / 3.0
                  : (_medium ? _width / 2.2 : _width / 2.1),
            ),
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      //margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Login",
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
      // margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Login to your account",
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
              // print("Routing");
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
        FocusScope.of(context).requestFocus(new FocusNode());
        if (emailController.text.toString().isEmpty) {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
            'Please enter a valid Email',
            style: TextStyle(
                fontSize: _large
                    ? kLargeFontSize
                    : (_medium ? kMediumFontSize : kSmallFontSize)),
          )));
        } else if (passwordController.text.toString().isEmpty) {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
            'Please enter a valid password',
            style: TextStyle(
                fontSize: _large
                    ? kLargeFontSize
                    : (_medium ? kMediumFontSize : kSmallFontSize)),
          )));
        } else {
          isConnected
              ? login(emailController.text.toString(),
                  passwordController.text.toString())
              : _showStatusDialog("No Internet Connection", null, "OK");
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _large ? _width / 2 : (_medium ? _width / 2.5 : _width / 2.25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: [Color(0xff0985ba), Color(0xff1a6ea8)],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('LOGIN',
            style: TextStyle(
                fontFamily: "Nunito",
                fontSize: _large
                    ? kLargeFontSize
                    : (_medium ? kMediumFontSize : kSmallFontSize))),
      ),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 80.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Are You A Driver?",
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
              Navigator.of(context).pushNamed(SIGN_UP);
            },
            child: Text(
              "Sign Up",
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
