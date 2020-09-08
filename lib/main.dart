import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/ui/CarCrashForm.dart';

import 'package:flutter_app/ui/signin.dart';
import 'package:flutter_app/ui/signup.dart';
import 'package:flutter_app/ui/splashscreen.dart';

// import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
     title: "Login",
    theme: ThemeData(primaryColor: Colors.orange[200]),
     routes: <String, WidgetBuilder>{
     SPLASH_SCREEN: (BuildContext context) =>SplashScreen(),
     SIGN_IN: (BuildContext context) =>  SignInPage(),
     SIGN_UP: (BuildContext context) =>  SignUpScreen(),
     HOME: (BuildContext context) =>  CarCrashForm(),
    },
    initialRoute: SPLASH_SCREEN,
   )
  );
}


















