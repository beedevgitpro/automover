import 'dart:async';
import 'dart:convert';
// import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/ui/widgets/responsive_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/model/carcrashmodel.dart';
// import 'package:flutter_app/ui/drawer.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'dart:ui' as UI;

class CarCrashForm extends StatefulWidget {
  CarCrashForm({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CarCrashForm> {
  final _formKey = GlobalKey<FormState>();
  FocusNode receiverDetailsFocusNode = FocusNode();
  FocusNode senderDetailsFocusNode = FocusNode();
  bool toBeSubmitted=false;
  bool isConnected=true;
  double _value = 0.0;
  List<String> vehicleCondition = ['Low', 'Fair', 'Good'];
  // double _secondValue = 0.0;
  double _value1 = 0;
  String username = "";
  // double _secondValue1 = 0.0;
  bool isSwitched = true;
  String base64Imagecar = "";
  String base64Imageboat = "";
  String base64Imagesendersign = "";
  String base64Imagerecieversign = "";
  String externalCondition = "Low";
  String internalCondition = "Low";
  bool isSwitched1 = true;
  String dropdownValue = 'Honda';
  String dropdownValue1 = 'Honda';
  String token;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  var subscription;
  var scr = new GlobalKey();
  var scr1 = new GlobalKey();
  var scr2 = new GlobalKey();
  var scr3 = new GlobalKey();
  TextEditingController regoController = TextEditingController();
  TextEditingController speedoController = TextEditingController();
  TextEditingController bookingIdController = TextEditingController();
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController othercommentController = TextEditingController();
  TextEditingController senderController = TextEditingController();
  TextEditingController recieverController = TextEditingController();

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.red,
    exportBackgroundColor: Colors.white,
  );
  final SignatureController _controller1 = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.red,
    exportBackgroundColor: Colors.white,
  );
  final SignatureController _controller2 = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.blueAccent,
    exportBackgroundColor: Colors.white,
  );
  final SignatureController _controller3 = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.blueAccent,
    exportBackgroundColor: Colors.white,
  );

  FlutterToast flutterToast;
  
  _showToast(var message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.blueAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12.0,
          ),
          Text(
            message,
            style: TextStyle(color: Colors.white,fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize)),
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

  @override
  void initState() {
    super.initState();
    print('initstate');
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print('Im in connectivity');
      
      setState(() {
        if(result.toString()=="ConnectivityResult.none"){
          isConnected=false;
        }
        else{
          isConnected=true;
          SharedPreferences.getInstance().then((value){
            if(value.getBool('toBeSubmitted')??false)
              CrashFormSubmit();
            });
        }
      });
    // Got a new connectivity status!
    print(result.toString());
    print(isConnected);
    });
    flutterToast = FlutterToast(context);
    dropdownValue = 'Honda';
    dropdownValue1 = 'Honda';
    externalCondition = "Low";
    internalCondition = "Low";
    _value = 0.0;
    // _secondValue = 0.0;
    _value1 = 0.0;
    // _secondValue1 = 0.0;
    isSwitched = false;
    isSwitched1 = false;
    fetchuser();
  }
  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
  void fetchuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      token = prefs.getString('token_security');
    });
  }

  Future<void> _showStatusDialog(String title, String msg) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Platform.isAndroid?AlertDialog(
            title: Text(title,style:TextStyle(fontWeight:FontWeight.bold,fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize))),
            content: Text(msg,style:TextStyle(fontSize: _large ? kLargeFontSize-2 : (_medium ? kMediumFontSize-2 : kSmallFontSize-2))),
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
          ):CupertinoAlertDialog(
            title: Text(title,style:TextStyle(fontWeight:FontWeight.bold,fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize))),
            content: Text(msg,style:TextStyle(fontSize: _large ? kLargeFontSize-2 : (_medium ? kMediumFontSize-2 : kSmallFontSize-2))),
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
  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Platform.isAndroid?AlertDialog(
            title: Text("Are you sure you want to logout?",style:TextStyle(fontWeight:FontWeight.bold,fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize))),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'No',
                 style:TextStyle(fontWeight:FontWeight.bold,fontSize: _large ? kLargeFontSize-2 : (_medium ? kMediumFontSize-2 : kSmallFontSize))
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  'Yes',
                  style:TextStyle(fontWeight:FontWeight.bold,fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize)),
                ),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("loggedIn");
                //prefs.setBool('toBeSubmitted',null);
                Navigator.of(context).pushNamedAndRemoveUntil(
              SIGN_IN, (Route<dynamic> route) => false);
                },
              ),
            ],
          ):CupertinoAlertDialog(
            title: Text("Are you sure you want to logout?"),
            actions: <Widget>[
              
              FlatButton(
                child: Text(
                  'No',
                  style: TextStyle(color: Color(0xff0985ba)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  'Yes',
                  style: TextStyle(color: Color(0xff0985ba)),
                ),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("loggedIn");
                //prefs.setBool('toBeSubmitted',null);
                Navigator.of(context).pushNamedAndRemoveUntil(
              SIGN_IN, (Route<dynamic> route) => false);
                },
              ),
            ],
          );
        });
  }
  void _saveData(){
    Map body={
      'user_id': '1',
      'job_no': bookingIdController.text.toString(),
      'sender_report': senderController.text.toString(),
      'receiver_report': recieverController.text.toString(),
      'maked': makeController.text.toString(),
      'model': modelController.text.toString(),
      'rego': regoController.text.toString(),
      'speedo': speedoController.text.toString(),
      'is_drivable': !isSwitched ? '2' : '1',
      'goods_inside': !isSwitched1 ? '2' : '1',
      'external_condition': externalCondition.toString() == "Low"
          ? '3'
          : externalCondition.toString() == "Fair" ? '2' : '1',
      'interior_condition': internalCondition.toString() == "Low"
          ? '3'
          : internalCondition.toString() == "Fair" ? '2' : '1',
      'survey_image': "data:image/png;base64," + base64Imagecar,
      'boat_view_data': "data:image/png;base64," + base64Imageboat,
      'comments': othercommentController.text.toString(),
      'sender_signature_data': "data:image/png;base64," + base64Imagesendersign,
      'receiver_signature_data':
          "data:image/png;base64," + base64Imagerecieversign,
    };
    SharedPreferences.getInstance().then((value){
      List<String>forms=value.getStringList('forms')??[];
      forms.add(jsonEncode(body));
      value.setStringList('forms',forms);
      value.setBool('toBeSubmitted', true);
    });
    setState(() {
          _controller.clear();
          _controller1.clear();
          _controller2.clear();
          _controller3.clear();
          regoController.clear();
          modelController.clear();
          makeController.clear();
          bookingIdController.clear();
          speedoController.clear();
          isSwitched1 = false;
          isSwitched = false;
          othercommentController.clear();
          senderController.clear();
          recieverController.clear();
        });
        _showStatusDialog('Data saved offline', 'Data will be submitted once device is online');
  }
  Future<CarCrashModel> CrashFormSubmit() async {
    ProgressDialog pr;
    pr = new ProgressDialog(context, isDismissible: false);
     SharedPreferences prefs = await SharedPreferences.getInstance();
    // print("sender_report" +
    //     senderController.text.toString() +
    //     "   recevier_report" +
    //     recieverController.text.toString() +
    //     "   maked" +
    //     dropdownValue.toString() +
    //     "   model" +
    //     dropdownValue1.toString() +
    //     "    regocontrller" +
    //     regoController.text.toString() +
    //     "    speedo" +
    //     speedoController.text.toString() +
    //     "   is_drivable" +
    //     isSwitched.toString() +
    //     "   good_inside" +
    //     isSwitched1.toString() +
    //     "   textinternal" +
    //     internalCondition.toString() +
    //     "    textext" +
    //     externalCondition.toString() +
    //     "     othercomment" +
    //     othercommentController.text.toString());
    await pr.show();
    List lst=prefs.getStringList('forms');
    final response = await http
        .post('https://automover.beedevstaging.com/api/post-survey', headers: {
      'Authorization': 'Bearer $token',
    }, body:(prefs.getBool('toBeSubmitted')??false)?jsonDecode(lst[0]):
    {
      'user_id': '1',
      'job_no': bookingIdController.text.toString(),
      'sender_report': senderController.text.toString(),
      'receiver_report': recieverController.text.toString(),
      'maked': makeController.text.toString(),
      'model': modelController.text.toString(),
      'rego': regoController.text.toString(),
      'speedo': speedoController.text.toString(),
      'is_drivable': !isSwitched ? '2' : '1',
      'goods_inside': !isSwitched1 ? '2' : '1',
      'external_condition': externalCondition.toString() == "Low"
          ? '3'
          : externalCondition.toString() == "Fair" ? '2' : '1',
      'interior_condition': internalCondition.toString() == "Low"
          ? '3'
          : internalCondition.toString() == "Fair" ? '2' : '1',
      'survey_image': "data:image/png;base64," + base64Imagecar,
      'boat_view_data': "data:image/png;base64," + base64Imageboat,
      'comments': othercommentController.text.toString(),
      'sender_signature_data': "data:image/png;base64," + base64Imagesendersign,
      'receiver_signature_data':
          "data:image/png;base64," + base64Imagerecieversign,
    });
    try {
      CarCrashModel carCrashModel = carCrashModelFromJson(response.body);
      print("carcrashresponse" + response.body.toString());
      if (carCrashModel.status == "success") {
        
        prefs.setString('forms',null);
        pr.hide();
        setState(() {
          _controller.clear();
          _controller1.clear();
          _controller2.clear();
          _controller3.clear();
          regoController.clear();
          modelController.clear();
          makeController.clear();
          bookingIdController.clear();
          speedoController.clear();
          isSwitched1 = false;
          isSwitched = false;
          othercommentController.clear();
          senderController.clear();
          recieverController.clear();
        });
        //  Navigator.of(context).pop();
        
        if(prefs.getBool('toBeSubmitted')??false)
        {if(lst.length>1){
          lst.removeAt(0);
          prefs.setStringList('forms', lst);
          CrashFormSubmit();
        }
        else
        {
          _showStatusDialog("Thank you for submitting!", (prefs.getBool('toBeSubmitted')??false)?"Previous offline submission recorded":"Submission recorded.");
          prefs.setBool('toBeSubmitted',false);
          prefs.remove('forms');
        }}
          

//        SharedPreferences prefs = await SharedPreferences.getInstance();
//        prefs.setString('loggedIn', "true");
//        //   prefs.setString('userid', );
//        prefs.setString('token_security',singinrespdata.token);

      } else {
        pr.hide();
        prefs.setString('forms',null);
       toBeSubmitted?_showStatusDialog("Couldn't submit saved offline data",""):_showStatusDialog("Something Went Wrong", carCrashModel.status);
        //prefs.setBool('toBeSubmitted',false);
        //_showToast(carCrashModel.status);
      }
    } catch (e) {
      pr.hide();
      _showStatusDialog("Something Went Wrong", "Reverify entered information");
      print(e);
      //prefs.setBool('toBeSubmitted',false);
      //_showToast("Something Went Wrong" + response.body);
    }
  }

  void handleClick(String value) async {
    switch (value) {
      case 'Logout':
        {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove("loggedIn");
          Navigator.of(context).pushNamedAndRemoveUntil(
              SIGN_IN, (Route<dynamic> route) => false);
          break;
        }
      case 'Settings':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff0985ba),
            title: Text(
              'Vehicle Survey Report',
              style: TextStyle(fontFamily: "Nunito",fontSize: _large ? kLargeFontSize+5 : (_medium ? kMediumFontSize+2 : kSmallFontSize)),
            ),
            actions: <Widget>[
              new Image.asset(
                'assets/img/logo.png',
                width: _large ? 120 : 85,
                height:_large ? 120 : 85,
              ),
              SizedBox(width:5),
              IconButton(icon: Icon(Icons.exit_to_app,size: _large ? 32 : 28,), onPressed:_showLogoutConfirmationDialog),
              // PopupMenuButton<String>(
              //   onSelected: handleClick,
              //   itemBuilder: (BuildContext context) {
              //     return {'Logout'}.map((String choice) {
              //       return PopupMenuItem<String>(
              //         value: choice,
              //         child: Text(choice),
              //       );
              //     }).toList();
              //   },
              // ),
            ],
          ),
          body: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  color: Color(0xff1a6ea8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Job/Booking Ref #",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                        fontFamily: "Nunito"),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 10, 0),
                                    child: TextFormField(
                                      cursorColor: Colors.white,
                                      inputFormatters: [
                                              WhitelistingTextInputFormatter.digitsOnly
                                            ],
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return 'This field is required';
                                      },
                                      style: TextStyle(
                                          fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                          fontFamily: "Nunito",
                                          color: Color(0xffffffff)),
                                      controller: bookingIdController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[200])),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Surveyed By  ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Nunito"),
                              ),
                              Text(
                                username + "  ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                    fontFamily: "Nunito"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: myBoxDecoration(),
                        child: _tabSection(context),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Column(children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(0),
                          child: Table(
                            border: TableBorder.all(color: Color(0xffb3b3b3)),
                            columnWidths: {
                              0: FractionColumnWidth(0.5),
                              1: FractionColumnWidth(.5)
                            },
                            children: [
                              TableRow(children: [
                                Padding(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Make',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                                fontFamily: "Nunito"),
                                          ),
                                        ),
                                        Expanded(
                                          flex:2,
                                          child: TextFormField(
                                            style: TextStyle(
                                                fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                                fontFamily: "Nunito"),
                                            controller: makeController,
                                            decoration: InputDecoration(
                                                enabledBorder: InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                hintText:
                                                    '${_large ? 'Manufacturer Name' : 'Manufacturer'}'),
                                            validator: (value) {
                                              if (value.isEmpty)
                                                return 'Required';
                                            },
                                          ),
                                        ),
                                      ]),
                                  padding: const EdgeInsets.all(10),
                                ),
                                Padding(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex:2,
                                          child: Text(
                                            'Model',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                                fontFamily: "Nunito"),
                                          ),
                                        ),
                                        Expanded(
                                          flex:2,
                                          child: TextFormField(
                                            style: TextStyle(
                                                fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                                fontFamily: "Nunito"),
                                            controller: modelController,
                                            decoration: InputDecoration(
                                                enabledBorder: InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                hintText:
                                                    '${MediaQuery.of(context).size.width >= 600 ? 'Model Number' : 'Model'}'),
                                            validator: (value) {
                                              if (value.isEmpty)
                                                return 'Required';
                                            },
                                          ),
                                        ),
                                      ]),
                                  padding: const EdgeInsets.all(10),
                                ),
                              ]),
                              TableRow(children: [
                                Padding(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Rego',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                                fontFamily: "Nunito"),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                            style: TextStyle(
                                                fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                                fontFamily: "Nunito"),
                                            controller: regoController,
                                            decoration: InputDecoration(
                                                errorBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                hintText: 'Registration'),
                                            validator: (value) {
                                              if (value.isEmpty)
                                                return 'Required';
                                            },
                                          ),
                                        ),
                                      ]),
                                  padding: const EdgeInsets.all(10),
                                ),
                                Padding(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex:2,
                                          child: Text(
                                            'Speedo',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                                fontFamily: "Nunito"),
                                          ),
                                        ),
                                        Expanded(
                                          flex:2,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              WhitelistingTextInputFormatter.digitsOnly
                                            ],
                                            style: TextStyle(
                                                fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                                fontFamily: "Nunito"),
                                            controller: speedoController,
                                            decoration: InputDecoration(
                                                errorBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                hintText: 'Speedo'),
                                            validator: (value) {
                                              if (value.isEmpty)
                                                return 'Required';
                                            },
                                          ),
                                        ),
                                      ]),
                                  padding: const EdgeInsets.all(10),
                                ),
                              ]),
                              TableRow(children: [
                                Padding(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: _large
                                              ? 9
                                              : 4,
                                          child: Text(
                                            'Drivable',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                                fontFamily: "Nunito"),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Transform.scale(
                                            scale: _large?1.5:1.2,
                                            child: Switch.adaptive(
                                              value: isSwitched,
                                              onChanged: (value) {
                                                setState(() {
                                                  isSwitched = value;
                                                });
                                              },
                                              activeTrackColor: Colors.teal,
                                              activeColor: Platform.isAndroid?Colors.white:Colors.teal,
                                            ),
                                          ),
                                        )
                                      ]),
                                  padding: const EdgeInsets.all(10),
                                ),
                                Padding(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: _large
                                              ? 9
                                              : 4,
                                          child: Text(
                                            'Goods Inside',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                                fontFamily: "Nunito"),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Transform.scale(
                                            scale: _large?1.5:1.2,
                                            child: Switch.adaptive(
                                              value: isSwitched1,
                                              onChanged: (value) {
                                                setState(() {
                                                  isSwitched1 = value;
                                                });
                                              },
                                              activeTrackColor: Colors.teal,
                                              activeColor: Platform.isAndroid?Colors.white:Colors.teal,
                                            ),
                                          ),
                                        )
                                      ]),
                                  padding: const EdgeInsets.all(10),
                                ),
                              ]),
                              TableRow(children: [
                                Padding(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'External Condition',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                              fontFamily: "Nunito"),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Stack(
                                                  alignment: Alignment.center,
                                                  fit: StackFit.loose,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      height: _large?20:10,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            10)),
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets.only(right:_large?3:0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            10)),
                                                                color:
                                                                    Colors.teal,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      child: SliderTheme(
                                                        data: SliderThemeData(
                                                          activeTickMarkColor:
                                                              Colors.transparent,
                                                          inactiveTickMarkColor:
                                                              Colors.transparent,
                                                          activeTrackColor:
                                                              Colors.transparent,
                                                          inactiveTrackColor:
                                                              Colors.transparent,
                                                          thumbColor:
                                                              Colors.white,
                                                          thumbShape: RoundSliderThumbShape(
                                                            elevation:6,
                                                            enabledThumbRadius: _large?18:12
                                                          ),
                                                          overlayShape:
                                                              RoundSliderOverlayShape(
                                                                  overlayRadius:
                                                                      10.0),
                                                        ),
                                                        child: Slider(
                                                          divisions: 2,
                                                          min: 0,
                                                          max: 2,
                                                          value: _value,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _value = value;
                                                              externalCondition =
                                                                  vehicleCondition[
                                                                      value
                                                                          .toInt()];
                                                              print(_value);
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    )
//                                                     Container(
//                                                       child: SeekBar(
//                                                         barColor:
//                                                             Colors.transparent,
//                                                         thumbColor:
//                                                             Colors.grey[200],
//                                                         thumbRadius: 12,
//                                                         progressWidth: 3,
//                                                         value: _value,
//                                                         secondValue:
//                                                             _secondValue,
//                                                         progressColor:
//                                                             Colors.transparent,
//                                                         secondProgressColor:
//                                                             Colors.transparent,
//                                                         onStartTrackingTouch:
//                                                             () {
//                                                           print(
//                                                               'onStartTrackingTouch');
// //                                            if (!_done) {
// //                                              _progressTimer?.cancel();
// //                                            }
//                                                         },
//                                                         onProgressChanged:
//                                                             (value) {
//                                                           print(
//                                                               'onProgressChanged:$value');
//                                                           _value = value;
//                                                           setState(() {
//                                                             if (_value >=
//                                                                 0.66) {
//                                                               externalCondition =
//                                                                   "Good";
//                                                             } else if (_value <
//                                                                     0.66 &&
//                                                                 _value >=
//                                                                     0.33) {
//                                                               externalCondition =
//                                                                   "Fair";
//                                                             } else
//                                                               externalCondition =
//                                                                   "Low";
//                                                           });
//                                                         },
//                                                         onStopTrackingTouch:
//                                                             () {
//                                                           print(
//                                                               'onStopTrackingTouch');
// //                                            if (!_done) {
// //                                              _resumeProgressTimer();
// //                                            }
//                                                         },
//                                                       ),
//                                                     ),
                                                  ]),
                                              flex: 2,
                                            ),
                                            Expanded(
                                                child: Text(
                                                  externalCondition,
                                                  style: TextStyle(
                                                      fontSize:_large
                                                              ? 25
                                                              : 18,
                                                      color: Colors.black,
                                                      fontFamily: "Nunito"),
                                                  textAlign: TextAlign.center,
                                                ),
                                                flex: 1)
                                          ],
                                        )
                                      ]),
                                  padding: const EdgeInsets.all(10),
                                ),
                                Padding(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Internal Condition',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                              fontFamily: "Nunito"),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: Stack(
                                                  alignment: Alignment.center,
                                                  fit: StackFit.loose,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      height: _large?20:10,
                                                      // decoration: BoxDecoration(
                                                      //   borderRadius: BorderRadius.circular(10),
                                                      //  gradient: LinearGradient(colors: [Colors.red,Colors.amber,Colors.green]),
                                                      // ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10)),
                                                              color: Colors.red,
                                                            ),
                                                          )),
                                                          Expanded(
                                                              child: Container(
                                                            color: Colors.amber,
                                                          )),
                                                          Expanded(
                                                              child: Container(
                                                                margin: EdgeInsets.only(right:_large?3:0),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          10)),
                                                              color:
                                                                  Colors.teal,
                                                            ),
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                                    SliderTheme(
                                                      data: SliderThemeData(
                                                        activeTickMarkColor:
                                                            Colors.transparent,
                                                        inactiveTickMarkColor:
                                                            Colors.transparent,
                                                        activeTrackColor:
                                                            Colors.transparent,
                                                        inactiveTrackColor:
                                                            Colors.transparent,
                                                        thumbColor:
                                                            Colors.white,
                                                        thumbShape: RoundSliderThumbShape(
                                                          elevation:6,
                                                          enabledThumbRadius: _large?18:12
                                                        ),
                                                        overlayShape:
                                                            RoundSliderOverlayShape(
                                                                overlayRadius:
                                                                    10.0),
                                                      ),
                                                      child: Slider(
                                                        divisions: 2,
                                                        min: 0,
                                                        max: 2,
                                                        value: _value1,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _value1 = value;
                                                            internalCondition =
                                                                vehicleCondition[
                                                                    value
                                                                        .toInt()];
                                                            print(_value1);
                                                          });
                                                        },
                                                      ),
                                                    )
//                                                     SeekBar(
//                                                       barColor:
//                                                           Colors.transparent,
//                                                       thumbColor:
//                                                           Colors.grey[200],
//                                                       thumbRadius: 12,
//                                                       progressWidth: 3,
//                                                       value: _value1,
//                                                       secondValue:
//                                                           _secondValue1,
//                                                       progressColor:
//                                                           Colors.transparent,
//                                                       secondProgressColor:
//                                                           Colors.transparent,
//                                                       onStartTrackingTouch: () {
//                                                         print(
//                                                             'onStartTrackingTouch');
//                                                       },
//                                                       onProgressChanged:
//                                                           (value) {
//                                                         print(
//                                                             'onProgressChanged:$value');
//                                                         setState(() {
//                                                           _value1 = value;
//                                                           if (_value1 >= 0.66) {
//                                                             internalCondition =
//                                                                 "Good";
//                                                           } else if (_value1 <
//                                                                   0.66 &&
//                                                               _value1 >= 0.33) {
//                                                             internalCondition =
//                                                                 "Fair";
//                                                           } else
//                                                             internalCondition = "Low";
//                                                         });
//                                                       },
//                                                       onStopTrackingTouch: () {
//                                                         print(
//                                                             'onStopTrackingTouch');
// //                                            if (!_done) {
// //                                              _resumeProgressTimer();
// //                                            }
//                                                       },
//                                                     ),
                                                  ]),
                                              flex: 2,
                                            ),
                                            Expanded(
                                                child: Text(
                                                  internalCondition,
                                                  style: TextStyle(
                                                      fontSize:_large
                                                              ? 25
                                                              : 18,
                                                      color: Colors.black,
                                                      fontFamily: "Nunito"),
                                                  textAlign: TextAlign.center,
                                                ),
                                                flex: 1)
                                          ],
                                        )
                                      ]),
                                  padding: const EdgeInsets.all(10),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "X- Dent S -Scratch C -Cracked R Rust",
                        style: TextStyle(
                            fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Nunito"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Diagram to show major/obvious damage only -damaged vehicles will not be survyed",
                        style: TextStyle(
                            fontSize: _large ? kLargeFontSize-3 : (_medium ? kMediumFontSize-3 : kSmallFontSize-1),
                            color: Colors.grey,
                            fontFamily: "Nunito"),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        child: GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                            child: Icon(
                              Icons.clear,
                              color: Color(0xff1a6ea8),
                            ),
                          ),
                          onTap: () {
                            _controller.clear();
                          },
                        ),
                        alignment: Alignment.topLeft,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(18),
                          child: RepaintBoundary(
                            key: scr,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/img/carmover.svg',
                                  width: MediaQuery.of(context).size.width,
                                  //height: MediaQuery.of(context).size.width/0.9,
                                  //height: 700,
                                  height: _large?700:500,
                                ),
                                Signature(
                                  controller: _controller,
                                  width: MediaQuery.of(context).size.width*0.9,
                                  height: _large?700:500,
                                  backgroundColor: Colors.transparent,
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Boat/C/Van/Trlr Survey",
                        style: TextStyle(
                            fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Nunito"),
                      ),
                      Align(
                        child: GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                            child: Icon(
                              Icons.clear,
                              color: Color(0xff1a6ea8),
                            ),
                          ),
                          onTap: () {
                            _controller1.clear();
                          },
                        ),
                        alignment: Alignment.topLeft,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(18),
                          child: RepaintBoundary(
                            key: scr1,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/img/car-top.svg',
                                  width: MediaQuery.of(context).size.width*0.9,
                                  height: _large?600:400,
                                ),
                                Signature(
                                  controller: _controller1,
                                  width: MediaQuery.of(context).size.width*0.9,
                                  height: _large?600:400,
                                  backgroundColor: Colors.transparent,
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                  decoration: myBoxDecoration(),
                                  child: Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Other Comments",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                                  fontFamily: "Nunito"),
                                            ),
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 0, 0),
                                        child: TextFormField(
                                          controller: othercommentController,
                                          style: TextStyle(
                                              color: Color(0xff000000),
                                              fontSize: 18,
                                              fontFamily: "Nunito"),
//                               initialValue: "Write Message,
                                          textInputAction: TextInputAction.done,
                                          validator: (text) {
                                            if (text == null ||
                                                text.isEmpty ||
                                                text.trim().isEmpty) {
                                              return 'Required';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            errorBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,

                                            focusedErrorBorder:
                                                InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            hintText: "Write Message",
                                            hintStyle: TextStyle(
                                              fontSize: _large ? kLargeFontSize-2 : (_medium ? kMediumFontSize-2 : kSmallFontSize),
                                              fontFamily: "Nunito",
                                              color: Color(0xff999999),
                                            ),
// labelText: 'Enter
                                          ),

// onEditingComplete: ()=>print(abc),

                                          maxLines: 8,
                                        ),
                                      ),
                                      Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      " Reciever Signature",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                                          fontFamily: "Nunito",
                                                          color: Color(0xff000000)),
                                                    ),
                                                    GestureDetector(
                                                  child: Padding(
                                                    padding: EdgeInsetsDirectional.only(end:5),
                                                    child: Icon(
                                                      Icons.clear,
                                                      color: Color(0xff1a6ea8),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    _controller2.clear();
                                                  },
                                                ),
                                                  ],
                                                ),
                                                RepaintBoundary(
                                                  key: scr2,
                                                      child: Signature(
                                                    controller: _controller2,
                                                    height: _large?150:100,
                                                    width: MediaQuery.of(context).size.width*0.9,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      color:
                                                          Color(0xffb0b0b0))),
                                            ),
                                          ),
                                          Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      " Sender Signature",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                                          fontFamily: "Nunito",
                                                          color: Color(0xff000000)),
                                                    ),
                                                    GestureDetector(
                                                  child: Padding(
                                                    padding: EdgeInsetsDirectional.only(end:5),
                                                    child: Icon(
                                                      Icons.clear,
                                                      color: Color(0xff1a6ea8),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    _controller3.clear();
                                                  },
                                                ),
                                                  ],
                                                ),
                                                RepaintBoundary(
                                                  key:scr3,
                                                    child: Signature(
                                                    controller: _controller3,
                                                    height:_large?150:100,
                                                    width: MediaQuery.of(context).size.width*0.9,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    top: BorderSide(
                                                        color:
                                                            Color(0xffb0b0b0)),
                                                    )),
                                          )
                                     
                                    ],
                                  ))),
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
                      //   child: Align(
                      //     alignment: Alignment.centerLeft,
                      //     child: Text(
                      //       "Terms and Conditions:",
                      //       style: TextStyle(
                      //           fontSize: 15,
                      //           color: Colors.grey,
                      //           fontFamily: "Nunito"),
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      //   child: Align(
                      //     alignment: Alignment.bottomLeft,
                      //     child: Text(
                      //       "HLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.",
                      //       style: TextStyle(
                      //           fontSize: 15,
                      //           color: Colors.grey,
                      //           fontFamily: "Nunito"),
                      //       textAlign: TextAlign.left,
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    _controller.clear();
                                    _controller1.clear();
                                    _controller2.clear();
                                    _controller3.clear();
                                    regoController.clear();
                                    modelController.clear();
                                    makeController.clear();
                                    bookingIdController.clear();
                                    speedoController.clear();
                                    isSwitched1 = false;
                                    isSwitched = false;
                                    othercommentController.clear();
                                    senderController.clear();
                                    recieverController.clear();
                                  });
                                },
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(0.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Cancel",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: "Nunito"),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: RaisedButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    if (recieverController.text.isEmpty) {
                                    _showStatusDialog("Something's missing",
                                        "Reciever Details not Entered");
                                    receiverDetailsFocusNode.requestFocus();
                                  }
                                  else
                                    {  
                                      // var data = await _controller2.toPngBytes();
                                      // base64Imagesendersign = base64Encode(data);
                                      // var data1 = await _controller3.toPngBytes();
                                      // base64Imagerecieversign =
                                      //     base64Encode(data1);
                                      // print("sendersign" +
                                      //     base64Imagesendersign.toString());
                                      // print("recieversign" +
                                      //     base64Imagerecieversign.toString());
                                      await takescrshot();
                                      await takescrshot1();
                                      await takescrshotrecieverSign();
                                      await takescrshotsenderSign();
                                      try {
                                        final result =
                                            await InternetAddress.lookup(
                                                'google.com');
                                        if (result.isNotEmpty &&
                                            result[0].rawAddress.isNotEmpty) {
                                          CrashFormSubmit();
                                        }
                                      } on SocketException catch (_) {
                                        _saveData();
                                      }}
                                  }else {
                                    _showStatusDialog("Something's missing",
                                        "Reverify entered information");
                                  }
                                },
                                color: Color(0xff167db3),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(0.0)),
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    isConnected?"Submit":"Save Data",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Nunito",
                                        fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Color(0xffb0b0b0)),
    );
  }

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Column(
              children: [
                TabBar(
                    onTap: (index) {
                      index == 1
                          ? receiverDetailsFocusNode.requestFocus()
                          : senderDetailsFocusNode.requestFocus();
                    },
                    indicator: UnderlineTabIndicator(
                      borderSide:
                          BorderSide(color: Color(0xff1a6ea8), width: 3.0),
                    ),
                    indicatorColor: Color(0xff1a6ea8),
                    indicatorWeight: 1,
                    labelColor: Colors.black,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sender Details",
                            style: TextStyle(
                              fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                              fontFamily: "Nunito",
                            ),
                          ),
                          Icon(
                            Icons.edit,
                            color: Color(0xff848484),
                          ),
                        ],
                      )),
                      Tab(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Receiver Details",
                            style:
                                TextStyle(fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize), fontFamily: "Nunito"),
                          ),
                          Icon(Icons.add_circle_outline,
                              color: Color(0xff848484)),
                        ],
                      )),
                    ]),
                // Divider(
                //   color: Colors.grey,
                //   thickness: 1,
                // )
              ],
            ),
          ),
          Container(
            //Add this to give height
            height: 150,
            child: TabBarView(children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    focusNode: senderDetailsFocusNode,
                    maxLines: 5,
                    cursorColor: Color(0xff1a6ea8),
                    style: TextStyle(fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize), fontFamily: "Nunito"),
                    controller: senderController,
                    validator: (value) {
                      if (value.isEmpty) return 'This field is required';
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter Sender Details',
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                ),
              ),
              Container(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  maxLines: 5,
                  cursorColor: Color(0xff1a6ea8),
                  focusNode: receiverDetailsFocusNode,
                  style: TextStyle(fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize), fontFamily: "Nunito"),
                  controller: recieverController,
                  validator: (value) {
                    if (value.isEmpty) return 'This field is required';
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter Receiver Details',
                      errorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              )),
            ]),
          ),
        ],
      ),
    );
  }

  takescrshot() async {
    RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
    var image = await boundary.toImage(pixelRatio: 3);
    var byteData = await image.toByteData(format: UI.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    base64Imagecar = base64Encode(pngBytes);
    print(base64Encode(pngBytes));
  }

  takescrshot1() async {
    RenderRepaintBoundary boundary = scr1.currentContext.findRenderObject();
    var image = await boundary.toImage(pixelRatio:MediaQuery.of(context).size.width/250);
    var byteData = await image.toByteData(format: UI.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    base64Imageboat = base64Encode(pngBytes);
    print(base64Encode(pngBytes));
  }
  takescrshotrecieverSign()async{
    RenderRepaintBoundary boundary = scr2.currentContext.findRenderObject();
    var image = await boundary.toImage(pixelRatio:4.5);
    var byteData = await image.toByteData(format: UI.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    base64Imagerecieversign = base64Encode(pngBytes);
    print(base64Encode(pngBytes));
  }
  takescrshotsenderSign()async{
    RenderRepaintBoundary boundary = scr3.currentContext.findRenderObject();
    var image = await boundary.toImage(pixelRatio:4.5);
    var byteData = await image.toByteData(format: UI.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    base64Imagesendersign = base64Encode(pngBytes);
    print(base64Encode(pngBytes));
  }
}

//DropdownButton<String>(
//isExpanded: true,
//value: dropdownValue,
//icon: Icon(Icons.keyboard_arrow_down),
//iconSize: 24,
//elevation: 10,
//style: TextStyle(color: Colors.blueAccent),
//
//onChanged: (String newValue) {
//dropdownValue = newValue;
//setState(() {
//dropdownValue = newValue;
//});
//},
//items: <String>['Honda','Tesla', 'Maruti', 'Hyundai']
//.map<DropdownMenuItem<String>>((String value) {
//return DropdownMenuItem<String>(
//value: value,
//child: Text(value,
//style: TextStyle(fontSize:_large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),fontFamily: "Nunito",),),
//);
//}).toList(),
//),
