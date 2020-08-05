import 'dart:async';
import 'dart:convert';
// import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/ui/widgets/car_survey_painter.dart';
import 'package:flutter_app/ui/widgets/responsive_ui.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/model/carcrashmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_app/ui/drawer.dart';
import 'widgets/custom_progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'dart:ui' as UI;
import 'package:strings/strings.dart';

class CarCrashForm extends StatefulWidget {
  CarCrashForm({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CarCrashForm> {
  final _formKey = GlobalKey<FormState>();
  FocusNode receiverDetailsFocusNode = FocusNode();
  FocusNode senderDetailsFocusNode = FocusNode();
  bool err = false;
  final jobRefNode = FocusNode();
  final makeNode = FocusNode();
  final modelNode = FocusNode();
  final speedoNode = FocusNode();
  final regoNode = FocusNode();
  final sNameNode = FocusNode();
  final sPhoneNode = FocusNode();
  final sEmailNode = FocusNode();
  final sAddressNode = FocusNode();
  final commentNode = FocusNode();
  final rNameNode = FocusNode();
  final rPhoneNode = FocusNode();
  final rEmailNode = FocusNode();
  final rAddressNode = FocusNode();
  List<bool> isSelected=[true,false,false,false];
  List stack1=[];
  List<Map<String,dynamic>> redoStack=[];
  List<Point> pointlist1=[];
  List stack2=[];
  List redoStack2=[];
  List<Point> pointlist2=[];
  bool toBeSubmitted = false;
  bool isConnected = true;
  double _value = 0.0;
  List<String> vehicleCondition = ['Low', 'Fair', 'Good'];
  List<Map<String,dynamic>> markers=[];
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
  bool _autoValidate = false;
  final controller=ScrollController();
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
  TextEditingController senderNameController = TextEditingController();
  TextEditingController recieverNameController = TextEditingController();
  TextEditingController senderPhoneController = TextEditingController();
  TextEditingController recieverPhoneController = TextEditingController();
  TextEditingController senderEmailController = TextEditingController();
  TextEditingController recieverEmailController = TextEditingController();
  TextEditingController senderAddressController = TextEditingController();
  TextEditingController recieverAddressController = TextEditingController();
  Offset offset;
  String markerText='X';
  List toggleList=['Dent-X','Scratch-S','Rust-R','Cracked-C'];
  List toggleListMarkers=['X','S','R','C'];
  SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.red,
    exportBackgroundColor: Colors.white,
  );
  SignatureController _controller1 = SignatureController(
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
  List<File> images=[];
  final picker = ImagePicker();
  FlutterToast flutterToast;
      Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source,imageQuality: 60);
    setState(() {
      images.add(File(pickedFile.path));
      List<String> base64Images=[];
    for(File image in images)
      base64Images.add("'data:image/png;base64," + base64Encode(image.readAsBytesSync()).length.toString()+"'");
     
    });
  }
  _showToast(String message) {
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
      toastDuration: Duration(seconds: 2),
    );
  }
  getLocation()async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude,position.longitude);
    print(placemark[0].subThoroughfare+", "+placemark[0].thoroughfare +", "+placemark[0].subLocality+", "+placemark[0].locality+", "+placemark[0].administrativeArea+", "+placemark[0].country+". Pincode: "+placemark[0].postalCode+'.');
    print(position.longitude); 
  }
  @override
  void initState() {
    super.initState();
    //getLocation();
    //print('initstate');
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        if (result.toString() == "ConnectivityResult.none") {
          isConnected = false;
        } else {
          isConnected = true;
          SharedPreferences.getInstance().then((value) {
            if (value.getBool('toBeSubmitted') ?? false) CrashFormSubmit();
          });
        }
      });
      // Got a new connectivity status!
      // print(result.toString());
      // print(isConnected);
      
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
  void showImage(File file){
    Alert(context: context, title: '',style: AlertStyle(isOverlayTapDismiss: false,
        animationType: AnimationType.grow,isCloseButton: false),
        content: Stack(
         alignment: Alignment.center,
         children: [
           SpinKitChasingDots(color:kPrimaryColor,duration: Duration(milliseconds:800),),
           Image.file(file)
         ], 
        )
        ,buttons: [
        DialogButton(
          color: Colors.red,
          child: Text(
            'Remove'.toUpperCase(),
            style: TextStyle(
                color: Colors.white,
                fontSize: _large ? kLargeFontSize : kMediumFontSize),
          ),
          onPressed: () {
            setState(() {
                          images.removeWhere((element) => element==file);
            });
            Navigator.pop(context);
          },
        ),
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
          },
        )
      ],).show();
  }
  void fetchuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      token = prefs.getString('token_security');
    });
  }

  void _showStatusDialog(String title, String msg, String btnText) {
    Alert(
      context: context,
      title: title,
      desc: msg,
      style: AlertStyle(
        titleStyle: TextStyle(
            fontSize: _large ? kLargeFontSize + 6 : kMediumFontSize + 4),
        descStyle: TextStyle(
            fontWeight: FontWeight.normal,
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
            btnText.toUpperCase(),
            style: TextStyle(
                color: Colors.white,
                fontSize: _large ? kLargeFontSize : kMediumFontSize),
          ),
          onPressed: () {
            Navigator.pop(context);
            controller.jumpTo(controller.position.minScrollExtent);
            jobRefNode.requestFocus();
          },
        )
      ],
    ).show();
  }

  void _showLogoutConfirmationDialog() {
    Alert(
      context: context,
      title: 'Are you sure?',
      style: AlertStyle(
        animationType: AnimationType.grow,
        isOverlayTapDismiss: false,
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
          color: Colors.blueGrey,
          child: Text(
            "Logout".toUpperCase(),
            style: TextStyle(
                color: Colors.white,
                fontSize: _large ? kLargeFontSize : kMediumFontSize),
          ),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove("loggedIn");
            Navigator.of(context).pushNamedAndRemoveUntil(
                SIGN_IN, (Route<dynamic> route) => false);
           
          },
        ),
        DialogButton(
          color: Color(0xff167db3),
          child: Text(
            'Cancel'.toUpperCase(),
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

  void _saveData() {
    Map<String,String> base64Images={};
    for(File image in images)
      base64Images['image_${images.indexOf(image)+1}']="data:image/png;base64," + base64Encode(image.readAsBytesSync());
    
    Map body = {
      'user_id': '1',
      'job_no': bookingIdController.text.toString(),
      'sender_name': senderNameController.text.toString(),
      'reciever_name': recieverNameController.text.toString(),
      'sender_phone': senderPhoneController.text.toString(),
      'reciever_phone': recieverPhoneController.text.toString(),
      'sender_email': senderEmailController.text.toString(),
      'reciever_email': recieverEmailController.text.toString(),
      'sender_address': senderAddressController.text.toString(),
      'reciever_address': recieverAddressController.text.toString(),
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
      // 'boat_view_data': "data:image/png;base64," + base64Imageboat,
      'comments': othercommentController.text.toString(),
      'sender_signature_data': "data:image/png;base64," + base64Imagesendersign,
      'receiver_signature_data':
          "data:image/png;base64," + base64Imagerecieversign,
      'images':jsonEncode(base64Images)
    };
    // print(body);
    // print("token="+token);
    SharedPreferences.getInstance().then((value) {
      List<String> forms = value.getStringList('forms') ?? [];
      forms.add(jsonEncode(body));
      value.setStringList('forms', forms);
      value.setBool('toBeSubmitted', true);
    });
    setState(() {
      _controller.clear();
      _formKey.currentState.reset();
      _controller1.clear();
      _controller2.clear();
      _controller3.clear();
      regoController.clear();
      modelController.clear();
      makeController.clear();
      bookingIdController.clear();
      err = false;
      speedoController.clear();
      isSwitched1 = false;
      isSwitched = false;
      othercommentController.clear();
     senderPhoneController.clear();
     images.clear();
     redoStack.clear();
          markers.clear();
          recieverPhoneController.clear();
          senderNameController.clear();
          recieverNameController.clear();
          senderAddressController.clear();
          recieverAddressController.clear();
          senderEmailController.clear();
          recieverEmailController.clear();
    });
    _showStatusDialog('Survey Saved Offline',
        'Survey will be submitted when Online', 'Start a New Survey');
  }

  Future<CarCrashModel> CrashFormSubmit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pr = ProgressDialog(context,isOfflineSubmit:(prefs.getBool('toBeSubmitted') ?? false));
    err = false;
    await pr.show();
    List lst = prefs.getStringList('forms');
    Map<String,String> base64Images={};
    print(token);
    for(File image in images)
      base64Images['image_${images.indexOf(image)+1}']="data:image/png;base64," + base64Encode(image.readAsBytesSync());
    print(jsonEncode(base64Images).toString());
    final response = await http.post(
        'https://autoaus.adtestbed.com/api/post-survey',
        // 'https://automover.beedevstaging.com/api/post-survey',
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: (prefs.getBool('toBeSubmitted') ?? false)
            ? jsonDecode(lst[0])
            : {
                'user_id': '1',
                'job_no': bookingIdController.text.toString(),
                'sender_name': senderNameController.text.toString(),
                'reciever_name': recieverNameController.text.toString(),
                'sender_phone': senderPhoneController.text.toString(),
                'reciever_phone': recieverPhoneController.text.toString(),
                'sender_email': senderEmailController.text.toString(),
                'reciever_email': recieverEmailController.text.toString(),
                'sender_address': senderAddressController.text.toString(),
                'reciever_address': recieverAddressController.text.toString(),
                'maked': makeController.text.toString(),
                'model': modelController.text.toString(),
                'rego': regoController.text.toString(),
                'speedo': speedoController.text.toString(),
                'is_drivable': !isSwitched ? '2'.toString() : '1'.toString(),
                'goods_inside': !isSwitched1 ? '2'.toString() : '1'.toString(),
                'external_condition': externalCondition.toString() == "Low"
                    ? '3'.toString()
                    : externalCondition.toString() == "Fair" ? '2'.toString() : '1'.toString(),
                'interior_condition': internalCondition.toString() == "Low"
                    ? '3'.toString()
                    : internalCondition.toString() == "Fair" ? '2'.toString() : '1'.toString(),
                'survey_image': "data:image/png;base64," + base64Imagecar,
                // 'boat_view_data': "data:image/png;base64," + base64Imageboat,
                'comments': othercommentController.text.toString(),
                'sender_signature_data':
                    "data:image/png;base64," + base64Imagesendersign,
                'receiver_signature_data':
                    "data:image/png;base64," + base64Imagerecieversign,
                    'images': jsonEncode(base64Images)
              });
    try {
      print("carcrashresponse" + response.body.toString());
      CarCrashModel carCrashModel = carCrashModelFromJson(response.body);
      print("carcrashresponse" + response.body.toString());
      if (carCrashModel.status == "success") {
        prefs.setString('forms', null);
        // pr.hide();
        pr.hide();
        setState(() {
          _formKey.currentState.reset();
          _controller.clear();
          images.clear();
          _controller1.clear();
          _controller2.clear();
          _controller3.clear();
          regoController.clear();
          modelController.clear();
          makeController.clear();
          bookingIdController.clear();
          speedoController.clear();
          redoStack.clear();
          markers.clear();
          err = false;
          isSwitched1 = false;
          isSwitched = false;
          othercommentController.clear();
          senderPhoneController.clear();
          recieverPhoneController.clear();
          senderNameController.clear();
          recieverNameController.clear();
          senderAddressController.clear();
          recieverAddressController.clear();
          senderEmailController.clear();
          recieverEmailController.clear();
        });
        //  Navigator.of(context).pop();

        if (prefs.getBool('toBeSubmitted') ?? false) {
          if (lst.length > 1) {
            lst.removeAt(0);
            prefs.setStringList('forms', lst);
            CrashFormSubmit();
          } else {
            _showStatusDialog(
                "Thank You for Submitting Survey",
                (prefs.getBool('toBeSubmitted') ?? false)
                    ? "Saved Surveys Submitted"
                    : "Survey Submitted",
                'Start a New Survey');
            prefs.setBool('toBeSubmitted', false);
            prefs.remove('forms');
          }
        } else {
          _showStatusDialog("Thank You for Submitting Survey",
              "Survey Submitted", 'Start a New Survey');
        }

//        SharedPreferences prefs = await SharedPreferences.getInstance();
//        prefs.setString('loggedIn', "true");
//        //   prefs.setString('userid', );
//        prefs.setString('token_security',singinrespdata.token);

      } else {
        pr.hide();
        prefs.setString('forms', null);
        toBeSubmitted
            ? _showStatusDialog(
                "Couldn't Submit Saved Surveys", null, 'Close')
            : _showStatusDialog(
                "Couldn't Submit Surveys", carCrashModel.status.toString(), 'Close');
        //prefs.setBool('toBeSubmitted',false);
        //_showToast(carCrashModel.status);
      }
    } catch (e) {
      pr.hide();
      _showStatusDialog("Couldn't Submit Surveys",null, 'Close');
      print(e);
      //prefs.setBool('toBeSubmitted',false);
      //_showToast("Something Went Wrong" + response.body);
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
            centerTitle: true,
            title: Text(
              'Vehicle Survey Report',
              style: TextStyle(
                  fontFamily: "Nunito",
                  fontSize: _large
                      ? kLargeFontSize + 5
                      : (_medium ? kMediumFontSize + 2 : kSmallFontSize)),
            ),
            flexibleSpace: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Image.asset(
                  'assets/img/logo.png',
                  // width: _large ? 65 : 40,
                  // height: _large ? 65 : 40.0,
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.bottomLeft,
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    size: _large ? 32 : 28,
                  ),
                  onPressed: _showLogoutConfirmationDialog),
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
          body: GestureDetector(
            onPanDown: (_) {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            // onTap: () {
            //    FocusScope.of(context).requestFocus(new FocusNode());
            // },
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
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
                                          fontSize: _large
                                              ? kLargeFontSize
                                              : (_medium
                                                  ? kMediumFontSize
                                                  : kSmallFontSize),
                                          fontFamily: "Nunito"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          5, 0, 10, 0),
                                      child: TextFormField(
                                        cursorColor: Colors.white,
                                        focusNode: jobRefNode,
                                        inputFormatters: [
                                          UpperCaseTextFormatter(),
                                        ],
                                        onFieldSubmitted: (value) {
                                          sNameNode.requestFocus();
                                        },
                                        textInputAction: TextInputAction.next,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            if (!err) {
                                              err = true;
                                              jobRefNode.requestFocus();
                                            }
                                            return 'Required';
                                          }
                                        },
                                        style: TextStyle(
                                            fontSize: _large
                                                ? kLargeFontSize
                                                : (_medium
                                                    ? kMediumFontSize
                                                    : kSmallFontSize),
                                            fontFamily: "Nunito",
                                            color: Color(0xffffffff)),
                                        controller: bookingIdController,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        //keyboardType: TextInputType.number,
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
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Surveyed By  ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: _large
                                            ? kLargeFontSize
                                            : (_medium
                                                ? kMediumFontSize
                                                : kSmallFontSize),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Nunito"),
                                  ),
                                  Text(
                                    capitalize(username.split(" ")[0] + " "),
                                    style: TextStyle(
                                        color: Colors.white,
                                        // fontWeight: FontWeight.bold,
                                        fontSize: _large
                                            ? kLargeFontSize
                                            : (_medium
                                                ? kMediumFontSize
                                                : kSmallFontSize),
                                        fontFamily: "Nunito"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Container(
                                  // decoration: myBoxDecoration(),
                                  child: Table(
                                    border: TableBorder.all(
                                        color: Color(0xffb3b3b3)),
                                    columnWidths: {
                                      0: FractionColumnWidth(0.5),
                                      1: FractionColumnWidth(.5)
                                    },
                                    children: [
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            'Sender Details',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: _large
                                                    ? kLargeFontSize
                                                    : (_medium
                                                        ? kMediumFontSize
                                                        : kSmallFontSize),
                                                fontFamily: "Nunito"),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            'Receiver Details',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: _large
                                                    ? kLargeFontSize
                                                    : (_medium
                                                        ? kMediumFontSize
                                                        : kSmallFontSize),
                                                fontFamily: "Nunito"),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Expanded(
                                                //   flex: 1,
                                                //   child: Text(
                                                //     'Name',
                                                //     style: TextStyle(
                                                //         fontWeight: FontWeight.bold,
                                                //         fontSize: _large
                                                //             ? kLargeFontSize
                                                //             : (_medium
                                                //                 ? kMediumFontSize
                                                //                 : kSmallFontSize),
                                                //         fontFamily: "Nunito"),
                                                //   ),
                                                // ),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextFormField(
                                                    onFieldSubmitted: (value) {
                                                      sPhoneNode.requestFocus();
                                                    },
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .words,
                                                    focusNode: sNameNode,
                                                    style: TextStyle(
                                                        fontSize: _large
                                                            ? kLargeFontSize
                                                            : (_medium
                                                                ? kMediumFontSize
                                                                : kSmallFontSize),
                                                        fontFamily: "Nunito"),
                                                    controller:
                                                        senderNameController,
                                                    decoration: InputDecoration(
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedErrorBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        hintText: 'Name'),
                                                    inputFormatters: [
                                                      
                                                    ],
                                                    // validator: (value) {
                                                    //   if (value.isEmpty) {
                                                    //     if (!err) {
                                                    //       err = true;
                                                    //       sNameNode
                                                    //           .requestFocus();
                                                    //     }
                                                    //     return 'Required';
                                                    //   }
                                                    // },
                                                  ),
                                                ),
                                              ]),
                                          padding: const EdgeInsets.all(8),
                                        ),
                                        Padding(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Expanded(
                                                //   flex: 2,
                                                //   child: Text(
                                                //     'Name',
                                                //     style: TextStyle(
                                                //         fontWeight: FontWeight.bold,
                                                //         fontSize: _large
                                                //             ? kLargeFontSize
                                                //             : (_medium
                                                //                 ? kMediumFontSize
                                                //                 : kSmallFontSize),
                                                //         fontFamily: "Nunito"),
                                                //   ),
                                                // ),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextFormField(
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .words,
                                                    inputFormatters: [
                                                      //UpperCaseTextFormatter(),
                                                    ],
                                                    onFieldSubmitted: (value) {
                                                      rPhoneNode.requestFocus();
                                                    },
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    focusNode: rNameNode,
                                                    style: TextStyle(
                                                        fontSize: _large
                                                            ? kLargeFontSize
                                                            : (_medium
                                                                ? kMediumFontSize
                                                                : kSmallFontSize),
                                                        fontFamily: "Nunito"),
                                                    controller:
                                                        recieverNameController,
                                                    decoration: InputDecoration(
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedErrorBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        hintText: 'Name'),
                                                    // validator: (value) {
                                                    //   if (value.isEmpty) {
                                                    //     if (!err) {
                                                    //       err = true;
                                                    //       rNameNode
                                                    //           .requestFocus();
                                                    //     }
                                                    //     return 'Required';
                                                    //   }
                                                    // },
                                                  ),
                                                ),
                                              ]),
                                          padding: const EdgeInsets.all(8),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Expanded(
                                                //   flex: 1,
                                                //   child: Text(
                                                //     'Phone Number',
                                                //     style: TextStyle(
                                                //         fontWeight: FontWeight.bold,
                                                //         fontSize: _large
                                                //             ? kLargeFontSize
                                                //             : (_medium
                                                //                 ? kMediumFontSize
                                                //                 : kSmallFontSize),
                                                //         fontFamily: "Nunito"),
                                                //   ),
                                                // ),
                                                Expanded(
                                                  flex: 1,
                                                  child: TextFormField(
                                                    onFieldSubmitted: (value) {
                                                      sEmailNode.requestFocus();
                                                    },
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    style: TextStyle(
                                                        fontSize: _large
                                                            ? kLargeFontSize
                                                            : (_medium
                                                                ? kMediumFontSize
                                                                : kSmallFontSize),
                                                        fontFamily: "Nunito"),
                                                    controller:
                                                        senderPhoneController,
                                                    decoration: InputDecoration(
                                                        errorBorder:
                                                            InputBorder.none,
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedErrorBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Phone Number'),
                                                    focusNode: sPhoneNode,
                                                    inputFormatters: [
                                                      WhitelistingTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    // validator: (value) {
                                                    //   if (value.isEmpty) {
                                                    //     if (!err) {
                                                    //       err = true;
                                                    //       sPhoneNode
                                                    //           .requestFocus();
                                                    //     }
                                                    //     return 'Required';
                                                    //   }
                                                    // },
                                                  ),
                                                ),
                                              ]),
                                          padding: const EdgeInsets.all(8),
                                        ),
                                        Padding(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Expanded(
                                                //   flex: 2,
                                                //   child: Text(
                                                //     'Phone Number',
                                                //     style: TextStyle(
                                                //         fontWeight: FontWeight.bold,
                                                //         fontSize: _large
                                                //             ? kLargeFontSize
                                                //             : (_medium
                                                //                 ? kMediumFontSize
                                                //                 : kSmallFontSize),
                                                //         fontFamily: "Nunito"),
                                                //   ),
                                                // ),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextFormField(
                                                    onFieldSubmitted: (value) {
                                                      rEmailNode.requestFocus();
                                                    },
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    inputFormatters: [
                                                      WhitelistingTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    focusNode: rPhoneNode,
                                                    style: TextStyle(
                                                        fontSize: _large
                                                            ? kLargeFontSize
                                                            : (_medium
                                                                ? kMediumFontSize
                                                                : kSmallFontSize),
                                                        fontFamily: "Nunito"),
                                                    controller:
                                                        recieverPhoneController,
                                                    decoration: InputDecoration(
                                                        errorBorder:
                                                            InputBorder.none,
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedErrorBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Phone Number'),
                                                    // validator: (value) {
                                                    //   if (value.isEmpty) {
                                                    //     if (!err) {
                                                    //       err = true;
                                                    //       rPhoneNode
                                                    //           .requestFocus();
                                                    //     }
                                                    //     return 'Required';
                                                    //   }
                                                    // },
                                                  ),
                                                ),
                                              ]),
                                          padding: const EdgeInsets.all(8),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: TextFormField(
                                                    onFieldSubmitted: (value) {
                                                      sAddressNode
                                                          .requestFocus();
                                                    },
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    focusNode: sEmailNode,
                                                    style: TextStyle(
                                                        fontSize: _large
                                                            ? kLargeFontSize
                                                            : (_medium
                                                                ? kMediumFontSize
                                                                : kSmallFontSize),
                                                        fontFamily: "Nunito"),
                                                    controller:
                                                        senderEmailController,
                                                    decoration: InputDecoration(
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedErrorBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        hintText: 'Email'),
                                                    inputFormatters: [
                                                      // UpperCaseTextFormatter(),
                                                    ],
                                                    // validator: (value) {
                                                    //   if (value.isEmpty) {
                                                    //     if (!err) {
                                                    //       err = true;
                                                    //       sEmailNode
                                                    //           .requestFocus();
                                                    //     }
                                                    //     return 'Required';
                                                    //   }
                                                    //   else if(!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(value)){
                                                    //     if (!err) {
                                                    //       err = true;
                                                    //       sEmailNode
                                                    //           .requestFocus();
                                                    //     }
                                                    //     return 'Invalid Email';
                                                    //   }
                                                    // },
                                                  ),
                                                ),
                                              ]),
                                          padding: const EdgeInsets.all(8),
                                        ),
                                        Padding(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Expanded(
                                                //   flex: 1,
                                                //   child: Text(
                                                //     'Email',
                                                //     style: TextStyle(
                                                //         fontWeight: FontWeight.bold,
                                                //         fontSize: _large
                                                //             ? kLargeFontSize
                                                //             : (_medium
                                                //                 ? kMediumFontSize
                                                //                 : kSmallFontSize),
                                                //         fontFamily: "Nunito"),
                                                //   ),
                                                // ),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextFormField(
                                                    inputFormatters: [
                                                      // UpperCaseTextFormatter(),
                                                    ],
                                                    onFieldSubmitted: (value) {
                                                      rAddressNode
                                                          .requestFocus();
                                                    },
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    focusNode: rEmailNode,
                                                    style: TextStyle(
                                                        fontSize: _large
                                                            ? kLargeFontSize
                                                            : (_medium
                                                                ? kMediumFontSize
                                                                : kSmallFontSize),
                                                        fontFamily: "Nunito"),
                                                    controller:
                                                        recieverEmailController,
                                                    decoration: InputDecoration(
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedErrorBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        hintText: 'Email'),
                                                    // validator: (value) {
                                                    //   if (value.isEmpty) {
                                                    //     if (!err) {
                                                    //       err = true;
                                                    //       rEmailNode
                                                    //           .requestFocus();
                                                    //     }
                                                    //     return 'Required';
                                                    //   }
                                                    //   else if(!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(value)){
                                                    //     if (!err) {
                                                    //       err = true;
                                                    //       rEmailNode
                                                    //           .requestFocus();
                                                    //     }
                                                    //     return 'Invalid Email';
                                                    //   }
                                                    // },
                                                  ),
                                                ),
                                              ]),
                                          padding: const EdgeInsets.all(8),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Expanded(
                                                //   flex: 1,
                                                //   child: Text(
                                                //     'Email',
                                                //     style: TextStyle(
                                                //         fontWeight: FontWeight.bold,
                                                //         fontSize: _large
                                                //             ? kLargeFontSize
                                                //             : (_medium
                                                //                 ? kMediumFontSize
                                                //                 : kSmallFontSize),
                                                //         fontFamily: "Nunito"),
                                                //   ),
                                                // ),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextFormField(
                                                    onFieldSubmitted: (value) {
                                                      rNameNode.requestFocus();
                                                    },
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    focusNode: sAddressNode,
                                                    style: TextStyle(
                                                        fontSize: _large
                                                            ? kLargeFontSize
                                                            : (_medium
                                                                ? kMediumFontSize
                                                                : kSmallFontSize),
                                                        fontFamily: "Nunito"),
                                                    controller:
                                                        senderAddressController,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .sentences,
                                                    decoration: InputDecoration(
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedErrorBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        hintText: 'Address'),
                                                    inputFormatters: [
                                                      // UpperCaseTextFormatter(),
                                                    ],
                                                    // validator: (value) {
                                                    //   if (value.isEmpty) {
                                                    //     if (!err) {
                                                    //       err = true;
                                                    //       sAddressNode
                                                    //           .requestFocus();
                                                    //     }
                                                    //     return 'Required';
                                                    //   }
                                                    // },
                                                  ),
                                                ),
                                              ]),
                                          padding: const EdgeInsets.all(8),
                                        ),
                                        Padding(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Expanded(
                                                //   flex: 1,
                                                //   child: Text(
                                                //     'Email',
                                                //     style: TextStyle(
                                                //         fontWeight: FontWeight.bold,
                                                //         fontSize: _large
                                                //             ? kLargeFontSize
                                                //             : (_medium
                                                //                 ? kMediumFontSize
                                                //                 : kSmallFontSize),
                                                //         fontFamily: "Nunito"),
                                                //   ),
                                                // ),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextFormField(
                                                    inputFormatters: [
                                                      // UpperCaseTextFormatter(),
                                                    ],
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .sentences,
                                                    onFieldSubmitted: (value) {
                                                      makeNode.requestFocus();
                                                    },
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    focusNode: rAddressNode,
                                                    style: TextStyle(
                                                        fontSize: _large
                                                            ? kLargeFontSize
                                                            : (_medium
                                                                ? kMediumFontSize
                                                                : kSmallFontSize),
                                                        fontFamily: "Nunito"),
                                                    controller:
                                                        recieverAddressController,
                                                    decoration: InputDecoration(
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedErrorBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        hintText: 'Address'),
                                                    // validator: (value) {
                                                    //   if (value.isEmpty) {
                                                    //     if (!err) {
                                                    //       err = true;
                                                    //       rAddressNode
                                                    //           .requestFocus();
                                                    //     }
                                                    //     return 'Required';
                                                    //   }
                                                    // },
                                                  ),
                                                ),
                                              ]),
                                          padding: const EdgeInsets.all(8),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Column(children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(0),
                                    child: Table(
                                      border: TableBorder.all(
                                          color: Color(0xffb3b3b3)),
                                      columnWidths: {
                                        0: FractionColumnWidth(0.5),
                                        1: FractionColumnWidth(.5)
                                      },
                                      children: [
                                        TableRow(children: [
                                          Padding(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      'Make',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: _large
                                                              ? kLargeFontSize
                                                              : (_medium
                                                                  ? kMediumFontSize
                                                                  : kSmallFontSize),
                                                          fontFamily: "Nunito"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: TextFormField(
                                                      onFieldSubmitted:
                                                          (value) {
                                                        modelNode
                                                            .requestFocus();
                                                      },
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      focusNode: makeNode,
                                                      style: TextStyle(
                                                          fontSize: _large
                                                              ? kLargeFontSize
                                                              : (_medium
                                                                  ? kMediumFontSize
                                                                  : kSmallFontSize),
                                                          fontFamily: "Nunito"),
                                                      controller:
                                                          makeController,
                                                          textCapitalization: TextCapitalization.characters,
                                                      decoration: InputDecoration(
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          focusedErrorBorder:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          errorBorder:
                                                              InputBorder.none,
                                                          hintText:
                                                              '${_large ? 'Manufacturer Name' : 'Manufacturer'}'),
                                                      inputFormatters: [
                                                        UpperCaseTextFormatter(),
                                                      ],
                                                      validator: (value) {
                                                        if (value.isEmpty) {
                                                          if (!err) {
                                                            err = true;
                                                            makeNode
                                                                .requestFocus();
                                                          }
                                                          return 'Required';
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ]),
                                            padding: const EdgeInsets.all(10),
                                          ),
                                          Padding(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      'Model',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: _large
                                                              ? kLargeFontSize
                                                              : (_medium
                                                                  ? kMediumFontSize
                                                                  : kSmallFontSize),
                                                          fontFamily: "Nunito"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: TextFormField(
                                                      inputFormatters: [
                                                        UpperCaseTextFormatter(),
                                                      ],
                                                      textCapitalization: TextCapitalization.characters,
                                                      onFieldSubmitted:
                                                          (value) {
                                                        regoNode.requestFocus();
                                                      },
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      focusNode: modelNode,
                                                      style: TextStyle(
                                                          fontSize: _large
                                                              ? kLargeFontSize
                                                              : (_medium
                                                                  ? kMediumFontSize
                                                                  : kSmallFontSize),
                                                          fontFamily: "Nunito"),
                                                      controller:
                                                          modelController,
                                                      decoration: InputDecoration(
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          focusedErrorBorder:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          errorBorder:
                                                              InputBorder.none,
                                                          hintText:
                                                              '${MediaQuery.of(context).size.width >= 600 ? 'Model Number' : 'Model'}'),
                                                      validator: (value) {
                                                        if (value.isEmpty) {
                                                          if (!err) {
                                                            err = true;
                                                            modelNode
                                                                .requestFocus();
                                                          }

                                                          return 'Required';
                                                        }
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      'Rego',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: _large
                                                              ? kLargeFontSize
                                                              : (_medium
                                                                  ? kMediumFontSize
                                                                  : kSmallFontSize),
                                                          fontFamily: "Nunito"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: TextFormField(
                                                      onFieldSubmitted:
                                                          (value) {
                                                        speedoNode
                                                            .requestFocus();
                                                      },
                                                      textCapitalization: TextCapitalization.characters,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      style: TextStyle(
                                                          fontSize: _large
                                                              ? kLargeFontSize
                                                              : (_medium
                                                                  ? kMediumFontSize
                                                                  : kSmallFontSize),
                                                          fontFamily: "Nunito"),
                                                      controller:
                                                          regoController,
                                                      decoration: InputDecoration(
                                                          errorBorder:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          focusedErrorBorder:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          hintText:
                                                              'Registration'),
                                                      focusNode: regoNode,
                                                      inputFormatters: [
                                                        UpperCaseTextFormatter(),
                                                      ],
                                                      validator: (value) {
                                                        if (value.isEmpty) {
                                                          if (!err) {
                                                            err = true;
                                                            regoNode
                                                                .requestFocus();
                                                          }
                                                          return 'Required';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ]),
                                            padding: const EdgeInsets.all(10),
                                          ),
                                          Padding(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      'Speedo',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: _large
                                                              ? kLargeFontSize
                                                              : (_medium
                                                                  ? kMediumFontSize
                                                                  : kSmallFontSize),
                                                          fontFamily: "Nunito"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: TextFormField(
                                                      onFieldSubmitted:
                                                          (value) {
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                      },
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        WhitelistingTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      focusNode: speedoNode,
                                                      style: TextStyle(
                                                          fontSize: _large
                                                              ? kLargeFontSize
                                                              : (_medium
                                                                  ? kMediumFontSize
                                                                  : kSmallFontSize),
                                                          fontFamily: "Nunito"),
                                                      controller:
                                                          speedoController,
                                                      decoration:
                                                          InputDecoration(
                                                              errorBorder:
                                                                  InputBorder
                                                                      .none,
                                                              enabledBorder:
                                                                  InputBorder
                                                                      .none,
                                                              focusedErrorBorder:
                                                                  InputBorder
                                                                      .none,
                                                              focusedBorder:
                                                                  InputBorder
                                                                      .none,
                                                              hintText:
                                                                  'Speedo'),
                                                      // validator: (value) {
                                                      //   if (value.isEmpty) {
                                                      //     if (!err) {
                                                      //       err = true;
                                                      //       speedoNode
                                                      //           .requestFocus();
                                                      //     }
                                                      //     return 'Required';
                                                      //   }
                                                      //   return null;
                                                      // },
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: _large ? 9 : 4,
                                                    child: Text(
                                                      'Drivable',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: _large
                                                              ? kLargeFontSize
                                                              : (_medium
                                                                  ? kMediumFontSize
                                                                  : kSmallFontSize),
                                                          fontFamily: "Nunito"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Transform.scale(
                                                      scale: _large ? 1.5 : 1.2,
                                                      child: Switch.adaptive(
                                                        value: isSwitched,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            isSwitched = value;
                                                          });
                                                        },
                                                        activeTrackColor:
                                                            Colors.teal,
                                                        activeColor:
                                                            Platform.isAndroid
                                                                ? Colors.white
                                                                : Colors.teal,
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                            padding: const EdgeInsets.all(10),
                                          ),
                                          Padding(
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: _large ? 9 : 4,
                                                    child: Text(
                                                      'Goods Inside',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: _large
                                                              ? kLargeFontSize
                                                              : (_medium
                                                                  ? kMediumFontSize
                                                                  : kSmallFontSize),
                                                          fontFamily: "Nunito"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Transform.scale(
                                                      scale: _large ? 1.5 : 1.2,
                                                      child: Switch.adaptive(
                                                        value: isSwitched1,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            isSwitched1 = value;
                                                          });
                                                        },
                                                        activeTrackColor:
                                                            Colors.teal,
                                                        activeColor:
                                                            Platform.isAndroid
                                                                ? Colors.white
                                                                : Colors.teal,
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'External Condition',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: _large
                                                            ? kLargeFontSize
                                                            : (_medium
                                                                ? kMediumFontSize
                                                                : kSmallFontSize),
                                                        fontFamily: "Nunito"),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            fit: StackFit.loose,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            5),
                                                                height: _large
                                                                    ? 20
                                                                    : 10,
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(10),
                                                                              bottomLeft: Radius.circular(10)),
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        color: Colors
                                                                            .amber,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            right: _large
                                                                                ? 3
                                                                                : 0),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius: BorderRadius.only(
                                                                              topRight: Radius.circular(10),
                                                                              bottomRight: Radius.circular(10)),
                                                                          color:
                                                                              Colors.teal,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                child:
                                                                    SliderTheme(
                                                                  data:
                                                                      SliderThemeData(
                                                                    activeTickMarkColor:
                                                                        Colors
                                                                            .transparent,
                                                                    inactiveTickMarkColor:
                                                                        Colors
                                                                            .transparent,
                                                                    activeTrackColor:
                                                                        Colors
                                                                            .transparent,
                                                                    inactiveTrackColor:
                                                                        Colors
                                                                            .transparent,
                                                                    thumbColor:
                                                                        Colors
                                                                            .white,
                                                                    thumbShape: RoundSliderThumbShape(
                                                                        elevation:
                                                                            6,
                                                                        enabledThumbRadius: _large
                                                                            ? 18
                                                                            : 12),
                                                                    overlayShape:
                                                                        RoundSliderOverlayShape(
                                                                            overlayRadius:
                                                                                10.0),
                                                                  ),
                                                                  child: Slider(
                                                                    divisions:
                                                                        2,
                                                                    min: 0,
                                                                    max: 2,
                                                                    value:
                                                                        _value,
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        _value =
                                                                            value;
                                                                        externalCondition =
                                                                            vehicleCondition[value.toInt()];
                                                                        print(
                                                                            _value);
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              )

                                                            ]),
                                                        flex: 2,
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                            externalCondition,
                                                            style: TextStyle(
                                                                fontSize: _large
                                                                    ? 25
                                                                    : 18,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Nunito"),
                                                            textAlign: TextAlign
                                                                .center,
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Internal Condition',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: _large
                                                            ? kLargeFontSize
                                                            : (_medium
                                                                ? kMediumFontSize
                                                                : kSmallFontSize),
                                                        fontFamily: "Nunito"),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Expanded(
                                                        child: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            fit: StackFit.loose,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            5),
                                                                height: _large
                                                                    ? 20
                                                                    : 10,
                                                                // decoration: BoxDecoration(
                                                                //   borderRadius: BorderRadius.circular(10),
                                                                //  gradient: LinearGradient(colors: [Colors.red,Colors.amber,Colors.green]),
                                                                // ),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child:
                                                                            Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius: BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(10),
                                                                            bottomLeft: Radius.circular(10)),
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                    )),
                                                                    Expanded(
                                                                        child:
                                                                            Container(
                                                                      color: Colors
                                                                          .amber,
                                                                    )),
                                                                    Expanded(
                                                                        child:
                                                                            Container(
                                                                      margin: EdgeInsets.only(
                                                                          right: _large
                                                                              ? 3
                                                                              : 0),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius: BorderRadius.only(
                                                                            topRight:
                                                                                Radius.circular(10),
                                                                            bottomRight: Radius.circular(10)),
                                                                        color: Colors
                                                                            .teal,
                                                                      ),
                                                                    ))
                                                                  ],
                                                                ),
                                                              ),
                                                              SliderTheme(
                                                                data:
                                                                    SliderThemeData(
                                                                  activeTickMarkColor:
                                                                      Colors
                                                                          .transparent,
                                                                  inactiveTickMarkColor:
                                                                      Colors
                                                                          .transparent,
                                                                  activeTrackColor:
                                                                      Colors
                                                                          .transparent,
                                                                  inactiveTrackColor:
                                                                      Colors
                                                                          .transparent,
                                                                  thumbColor:
                                                                      Colors
                                                                          .white,
                                                                  thumbShape: RoundSliderThumbShape(
                                                                      elevation:
                                                                          6,
                                                                      enabledThumbRadius:
                                                                          _large
                                                                              ? 18
                                                                              : 12),
                                                                  overlayShape:
                                                                      RoundSliderOverlayShape(
                                                                          overlayRadius:
                                                                              10.0),
                                                                ),
                                                                child: Slider(
                                                                  divisions: 2,
                                                                  min: 0,
                                                                  max: 2,
                                                                  value:
                                                                      _value1,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      _value1 =
                                                                          value;
                                                                      internalCondition =
                                                                          vehicleCondition[
                                                                              value.toInt()];
                                                                      print(
                                                                          _value1);
                                                                    });
                                                                  },
                                                                ),
                                                              )

                                                            ]),
                                                        flex: 2,
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                            internalCondition,
                                                            style: TextStyle(
                                                                fontSize: _large
                                                                    ? 25
                                                                    : 18,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "Nunito"),
                                                            textAlign: TextAlign
                                                                .center,
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
                                Padding(
                                  padding:EdgeInsets.symmetric(horizontal:16),
                                  child: Container(
                                    padding: EdgeInsets.zero,
                                    margin: EdgeInsets.zero,
                                    child: 
                                    LayoutBuilder(builder: (context, constraints) {
                                      return ToggleButtons(
                                      constraints:
                                            BoxConstraints.tight(Size.fromWidth(constraints.maxWidth / 4.1)),
                                      selectedColor:Colors.white,
                                      fillColor: kPrimaryColor,
                                      children: [
                                      for (String text in toggleList)
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical:10.0),
                                        child: Text(
                                        text,
                                        style: TextStyle(
                                            fontSize: _large
                                                ? kLargeFontSize-1
                                                : (_medium
                                                    ? kMediumFontSize-2
                                                    : kSmallFontSize-2),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Nunito"),
                                    ),
                                      ),
                                    ], isSelected:isSelected,onPressed: (index){
                                      setState(() {
                                        for(int i=0;i<isSelected.length;i++)
                                          {
                                            if(index==i)
                                             { 
                                                isSelected[i]=true;
                                                markerText=toggleListMarkers[i];
                                             }
                                            else
                                              isSelected[i]=false;
                                            }
                                      });
                                      
                                    },);
                                    })
                                    
                                  ),
                                ),
                                
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Diagram to show major/obvious damage only. Damaged vehicles will not be survyed",
                                  style: TextStyle(
                                      fontSize: _large
                                          ? kLargeFontSize - 2
                                          : (_medium
                                              ? kMediumFontSize - 1
                                              : kSmallFontSize - 1),
                                      color: Colors.black54,
                                      fontFamily: "Nunito"),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height:10),
                                Align(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal:10),
                                          child: Icon(Icons.undo,color:kPrimaryColor,size:_large?40:34),
                                          // Text("Undo",
                                          //     style: TextStyle(
                                          //       fontWeight: FontWeight.bold,
                                          //         fontSize: _large
                                          //             ? kLargeFontSize
                                          //             : (_medium
                                          //                 ? kMediumFontSize
                                          //                 : kSmallFontSize),
                                          //         color: Color(0xff1a6ea8),
                                          //         fontFamily: "Nunito")),
                                        ),
                                        onTap: () {
                                          
                                          setState(() {
                                            if(markers.isNotEmpty)
                                            redoStack.add(markers.removeLast());
                                          });
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                        },
                                      ),
                                     GestureDetector(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal:10),
                                          child: Icon(Icons.redo,color:kPrimaryColor,size:_large?40:34),
                                          // Text("Redo",
                                          //     style: TextStyle(
                                          //       fontWeight: FontWeight.bold,
                                          //         fontSize: _large
                                          //             ? kLargeFontSize
                                          //             : (_medium
                                          //                 ? kMediumFontSize
                                          //                 : kSmallFontSize),
                                          //         color: Color(0xff1a6ea8),
                                          //         fontFamily: "Nunito")),
                                        ),
                                        onTap: () {
                                          
                                          setState(() {
                                            if(redoStack.isNotEmpty)
                                            markers.add(redoStack.removeLast());
                                          });
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                        },
                                      ),
                                      GestureDetector(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal:15),
                                          child: Text("Clear All",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                  fontSize: _large
                                                      ? kLargeFontSize
                                                      : (_medium
                                                          ? kMediumFontSize
                                                          : kSmallFontSize),
                                                  color: Color(0xff1a6ea8),
                                                  fontFamily: "Nunito")),
                                        ),
                                        onTap: () {
                                          //_controller.clear();
                                          setState(() {
                                            markers.clear();
                                            redoStack.clear();
                                          });
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                        },
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.centerRight,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                    padding:EdgeInsets.symmetric(horizontal:18),
                                    child: RepaintBoundary(
                                        key: scr,
                                              child: Container(
                                                color: Colors.grey[200],
                                                child: GestureDetector(
                                                  onTapDown: (details){
                                                      //print(details.localPosition.dx);
                                                      setState(() {
                                                        markers.add({'text':markerText,'offset':details.localPosition});
                                                        redoStack.clear();
                                                        //offset=details.localPosition;vdvf
                                                      });
                                                    },
                                                    child: CustomPaint(
                                                      willChange: true,
                                                      
                                                    foregroundPainter: CarSurveyPainter(markers: markers,isLarge:_large),
                                                    child:SvgPicture.asset(
                                                        'assets/img/carmover.svg',
                                                        color: Colors.black,
                                                        width: MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                       
                                                        height: _large ? 700 : 500,
                                                      ),
                                                  ),
                                                ),
                                              ),
                                        
            
                                      ),
                                    ),
                                SizedBox(
                                  height: 30,
                                ),
                                // Text(
                                //   "Boat/C/Van/Trlr Survey",
                                //   style: TextStyle(
                                   
                                //       fontSize: _large
                                //           ? kLargeFontSize
                                //           : (_medium
                                //               ? kMediumFontSize
                                //               : kSmallFontSize),
                                //       fontWeight: FontWeight.bold,
                                //       fontFamily: "Nunito"),
                                // ),
                                // Align(
                                //   alignment: Alignment.centerRight,
                                //   child: Row(
                                //      mainAxisAlignment: MainAxisAlignment.center,

                                //     children: [
                                //       GestureDetector(
                                //         child: Padding(
                                //           padding: const EdgeInsets.fromLTRB(
                                //               10, 5, 10, 0),
                                //           child: Text("Undo",
                                //               style: TextStyle(
                                //                 fontWeight: FontWeight.bold,
                                //                   fontSize: _large
                                //                       ? kLargeFontSize
                                //                       : (_medium
                                //                           ? kMediumFontSize
                                //                           : kSmallFontSize),
                                //                   color: Color(0xff1a6ea8),
                                //                   fontFamily: "Nunito")),
                                //         ),
                                //         onTap: () {
                                //           _controller1.clear();
                                //           if(stack2.isNotEmpty)
                                //             {
                                //               //print(stack2[stack2.length-1].length);
                                //               stack2.removeAt(stack2.length-1);
                                //               //print('top popped');
                                //               if(stack2.isNotEmpty)
                                //              { 
                                //                print(stack2.length-1);
                                //                print(stack2[stack2.length-1].length);
                                //               for(Point point in stack2[(stack2.length)-1])
                                //               {
                                //                 setState(() {
                                //                  _controller1.addPoint(point);
                                //               });
                                //                 //_controller1.addPoint(point)
                                //               }
                                //               print('forend');
                                //               }
                                      
                                //               }
                                              
                                //           FocusScope.of(context)
                                //               .requestFocus(new FocusNode());
                                //         },
                                //       ),
                                //       GestureDetector(
                                //         child: Padding(
                                //           padding: const EdgeInsets.fromLTRB(
                                //               10, 5, 10, 0),
                                //           child: Text("Clear All",
                                //               style: TextStyle(
                                //                 fontWeight: FontWeight.bold,
                                //                   fontSize: _large
                                //                       ? kLargeFontSize
                                //                       : (_medium
                                //                           ? kMediumFontSize
                                //                           : kSmallFontSize),
                                //                   color: Color(0xff1a6ea8),
                                //                   fontFamily: "Nunito")),
                                //         ),
                                //         onTap: () {
                                //           _controller1.clear();
                                //           stack2.clear();
                                //           FocusScope.of(context)
                                //               .requestFocus(new FocusNode());
                                //         },
                                //       ),
                                //     ],
                                //   ),
                                  
                                // ),
                                // Padding(
                                //     padding: const EdgeInsets.all(18),
                                //     child: RepaintBoundary(
                                //       key: scr1,
                                //       child: Stack(
                                //         alignment: Alignment.center,
                                //         children: [
                                //           SvgPicture.asset(
                                //             'assets/img/car-top.svg',
                                //             color: Colors.black,
                                //             width: MediaQuery.of(context)
                                //                     .size
                                //                     .width *
                                //                 0.9,
                                //             height: _large ? 600 : 400,
                                //           ),
                                //           Listener(
                                //             onPointerUp:(pointerup){
                                //               //pointlist2=;
                                //               stack2.add(_controller1.value.toList());
                                //               //print(_controller.value);
                                //               for(var s in stack2)
                                //                 print(s.length);
                                //               //stack2.removeLast();
                                //             },
                                //             // onPanEnd: (details){
                                //             //   stack2.add(_controller1.points);
                                //             //   // stack2.add(_controller1.points);
                                //             //   // print(stack2);
                                //             //   print('end of stroke');
                                //             // },
                                //             child: Signature(
                                //               controller: _controller1,
                                //               width: MediaQuery.of(context)
                                //                       .size
                                //                       .width *
                                //                   0.9,
                                //               height: _large ? 600 : 400,
                                //               backgroundColor: Colors.black.withOpacity(0.05),
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     )),
                                // SizedBox(
                                //   height: 30,
                                // ),
                                Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                            decoration: myBoxDecoration(),
                                            child: Column(
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        "Other Comments",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: _large
                                                                ? kLargeFontSize
                                                                : (_medium
                                                                    ? kMediumFontSize
                                                                    : kSmallFontSize),
                                                            fontFamily:
                                                                "Nunito"),
                                                      ),
                                                    )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15, 0, 15, 0),
                                                  child: TextFormField(
                                                    controller:
                                                        othercommentController,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff000000),
                                                        fontSize:_large
                                                            ? kLargeFontSize
                                                            : (_medium
                                                                ? kMediumFontSize
                                                                : kSmallFontSize),
                                                        fontFamily: "Nunito"),
                                                    textCapitalization: TextCapitalization.sentences,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                  focusNode: commentNode,
                                                    // validator: (text) {
                                                    //   if (text == null ||
                                                    //       text.isEmpty ||
                                                    //       text.trim().isEmpty) {
                                                    //      if (!err) {
                                                    //       err = true;
                                                    //       commentNode
                                                    //           .requestFocus();
                                                    //     }
                                                    //     return 'Required';
          
                                                    //   }
                                                    //   return null;
                                                    // },
                                                    decoration: InputDecoration(
                                                      errorBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,

                                                      focusedErrorBorder:
                                                          InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      hintText:
                                                          "Type your comments here...",
                                                      hintStyle: TextStyle(
                                                        fontSize: _large
                                                            ? kLargeFontSize
                                                            : (_medium
                                                                ? kMediumFontSize
                                                                : kSmallFontSize),
                                                        fontFamily: "Nunito",
                                                        color:
                                                            Color(0xff999999),
                                                      ),

                                                    ),

                                                    maxLines: 8,
                                                  ),
                                                ),
                                                _large
                                                    ? Row(children: [
                                                        Expanded(
                                                          child: Container(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      " Reciever Signature",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize: _large
                                                                              ? kLargeFontSize
                                                                              : (_medium
                                                                                  ? kMediumFontSize
                                                                                  : kSmallFontSize),
                                                                          fontFamily:
                                                                              "Nunito",
                                                                          color:
                                                                              Color(0xff000000)),
                                                                    ),
                                                                    GestureDetector(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsetsDirectional.only(end: 5),
                                                                        child: Text(
                                                                            "Clear",
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight
                                                                              .bold,
                                                                                fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize  : kSmallFontSize),
                                                                                fontFamily: "Nunito",
                                                                                color: Color(0xff1a6ea8))),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        _controller2
                                                                            .clear();
                                                                        FocusScope.of(context)
                                                                            .requestFocus(new FocusNode());
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                                RepaintBoundary(
                                                                  key: scr2,
                                                                  child:
                                                                      Signature(
                                                                    controller:
                                                                        _controller2,
                                                                    height: _large
                                                                        ? 150
                                                                        : 100,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.49,
                                                                    backgroundColor:
                                                                        Colors.grey[
                                                                            200],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border(
                                                                  top: BorderSide(
                                                                      color: Color(
                                                                          0xffb0b0b0)),
                                                                  bottom: BorderSide(
                                                                      color: Color(
                                                                          0xffb0b0b0))),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      " Sender Signature",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize: _large
                                                                              ? kLargeFontSize
                                                                              : (_medium
                                                                                  ? kMediumFontSize
                                                                                  : kSmallFontSize),
                                                                          fontFamily:
                                                                              "Nunito",
                                                                          color:
                                                                              Color(0xff000000)),
                                                                    ),
                                                                    GestureDetector(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsetsDirectional.only(end: 5),
                                                                        child: Text(
                                                                            "Clear",
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight
                                                                              .bold,
                                                                                fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize : kSmallFontSize),
                                                                                fontFamily: "Nunito",
                                                                                color: Color(0xff1a6ea8))),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        _controller3
                                                                            .clear();
                                                                        FocusScope.of(context)
                                                                            .requestFocus(new FocusNode());
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                                RepaintBoundary(
                                                                  key: scr3,
                                                                  child:
                                                                      Signature(
                                                                    controller:
                                                                        _controller3,
                                                                    height: _large
                                                                        ? 150
                                                                        : 100,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.475,
                                                                    backgroundColor:
                                                                        Colors.grey[
                                                                            200],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border(
                                                                  top: BorderSide(
                                                                      color: Color(
                                                                          0xffb0b0b0)),
                                                                  left: BorderSide(
                                                                      color: Color(
                                                                          0xffb0b0b0)),
                                                                  bottom: BorderSide(
                                                                      color: Color(
                                                                          0xffb0b0b0))),
                                                            ),
                                                          ),
                                                        )
                                                      ])
                                                    : Column(
                                                        children: [
                                                          Container(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      " Reciever Signature",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize: _large
                                                                              ? kLargeFontSize
                                                                              : (_medium
                                                                                  ? kMediumFontSize
                                                                                  : kSmallFontSize),
                                                                          fontFamily:
                                                                              "Nunito",
                                                                          color:
                                                                              Color(0xff000000)),
                                                                    ),
                                                                    GestureDetector(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsetsDirectional.only(end: 5),
                                                                        child: Text(
                                                                            "Clear",
                                                                            style: TextStyle(
                                                                                fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize - 1 : kSmallFontSize),
                                                                                fontFamily: "Nunito",
                                                                                color: Color(0xff1a6ea8))),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        _controller2
                                                                            .clear();
                                                                        FocusScope.of(context)
                                                                            .requestFocus(new FocusNode());
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                                RepaintBoundary(
                                                                  key: scr2,
                                                                  child:
                                                                      Signature(
                                                                    controller:
                                                                        _controller2,
                                                                    height: _large
                                                                        ? 150
                                                                        : 120,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.885,
                                                                    backgroundColor:
                                                                        Colors.grey[
                                                                            200],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border(
                                                                  top: BorderSide(
                                                                      color: Color(
                                                                          0xffb0b0b0))),
                                                            ),
                                                          ),
                                                          Container(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      " Sender Signature",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize: _large
                                                                              ? kLargeFontSize
                                                                              : (_medium
                                                                                  ? kMediumFontSize
                                                                                  : kSmallFontSize),
                                                                          fontFamily:
                                                                              "Nunito",
                                                                          color:
                                                                              Color(0xff000000)),
                                                                    ),
                                                                    GestureDetector(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsetsDirectional.only(end: 5),
                                                                        child: Text(
                                                                            "Clear",
                                                                            style: TextStyle(
                                                                                fontSize: _large ? kLargeFontSize : (_medium ? kMediumFontSize - 1 : kSmallFontSize),
                                                                                fontFamily: "Nunito",
                                                                                color: Color(0xff1a6ea8))),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        FocusScope.of(context)
                                                                            .requestFocus(new FocusNode());
                                                                        _controller3
                                                                            .clear();
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                                RepaintBoundary(
                                                                  key: scr3,
                                                                  child:
                                                                      Signature(
                                                                    controller:
                                                                        _controller3,
                                                                    height: _large
                                                                        ? 150
                                                                        : 120,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.885,
                                                                    backgroundColor:
                                                                        Colors.grey[
                                                                            200],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                                    border:
                                                                        Border(
                                                              top: BorderSide(
                                                                  color: Color(
                                                                      0xffb0b0b0)),
                                                            )),
                                                          )
                                                        ],
                                                      ),
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
                                  height: 30,
                                ),
                                Container(
                                    child:
                                  Column(
                                    children: [
                                      
                                                      SizedBox(
                                  height: 6,
                                ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          
                                                  RaisedButton(
                                                    onPressed: ()async{
                                                      if(images.length<10)
                                                      await getImage(ImageSource.camera);
                                                      else
                                                        _showToast('Upload Limit Reached');
                                                    },
                                                    color: Color(0xff167db3),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            new BorderRadius.circular(
                                                                0.0)),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(10.0),
                                                      child: 
                                                          // Icon(Icons.add_a_photo,color: Colors.white),
                                                         Row(
                                                           children: [
                                                             Icon(Icons.camera_alt,color: Colors.white),
                                                             Align(
                                                                alignment: Alignment.center,
                                                                child: Text(' Upload Images',style: TextStyle(
                                                        fontFamily: "Nunito",
                                                        fontSize: _large
                                                                    ? kLargeFontSize
                                                                    : (_medium
                                                                        ? kMediumFontSize
                                                                        : kSmallFontSize),
                                                        color: Colors.white,
                                                        fontWeight:
                                                                    FontWeight.bold),),
                                                             ),
                                                           ],
                                                         ),
                                                          
                                                       
                                                    ),
                                                  ),
                                        ],
                                      ),
                                             SizedBox(height: 3,),
                                              Text('Upload Limit: 10 Images',style: TextStyle(
                                                        fontFamily: "Nunito",
                                                        fontSize: _large
                                                            ? kLargeFontSize-2
                                                            : (_medium
                                                                ? kMediumFontSize-1
                                                                : kSmallFontSize-1),
                                                        color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.normal),),
                                                          Wrap(
                                                            alignment: WrapAlignment.center,
                                                      
                                                            children: [
                                                              for(File i in images)
                                                              GestureDetector(
                                                                onTap: (){
                                                                  showImage(i);
                                                                },
                                                                             child: Padding(
                                                                               padding: EdgeInsets.all(8.0),
                                                                               child: Image.file(i,width: _width/8,),
                                                                             )
                                                                  
                                                              ),
                                                            
                                                            ],
                                                          ), 
                                    ],
                                  ),
                                  ),
                                SizedBox(
                                  height: 30,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:15.0),
                                      child: Text(
                                  "Received in Good Order and Condition.",
                                  style: TextStyle(
                                        fontSize: _large
                                            ? 15
                                            : (_medium
                                                ? 14
                                                : 13),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Nunito"),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: RichText(
                                  text:TextSpan(text:"Transport is subject to Terms and Conditions of Transit. To receive a copy please go to ",style: TextStyle(
                                        fontSize: _large
                                            ? 13
                                            : (_medium
                                                ? 12
                                                : 11),
                                        color: Colors.black54,
                                        fontFamily: "Nunito"),
                                        children:[
                                          TextSpan(text:"www.automover.com.au",recognizer: TapGestureRecognizer()..onTap=(){launch('https://www.automover.com.au');},style: TextStyle(color:Colors.blue)),
                                          TextSpan(
                                            
                                            text:"\n\nPlease note: Automover will not take responsibility for vehicles in poor condition, damaged vehicles, non drivable vehicles, contents inside vehicles, road damage, damage due to weather conditions, mechanical issues or vehicles that have been modified. If the driver is unable to survey the vehicle due to weather conditions, vehicle being dirty, dusty or night time pickup, Automover accepts no responsibility to the vehicle.")
                                        ],
                                        ),
                                  
                                  textAlign: TextAlign.left,
                                ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    child:
                                  RaisedButton(
                                            onPressed: () async {
                                              FocusScope.of(context)
                                                  .requestFocus(new FocusNode());
                                              if (_formKey.currentState
                                                  .validate()) {
                                              
                                                await takescrshot();
                                                //await takescrshot1();
                                                await takescrshotrecieverSign();
                                                await takescrshotsenderSign();
                                                _autoValidate = false;
                                             
                                                isConnected
                                                    ? CrashFormSubmit()
                                                    : _saveData();
                                              } else {
                                                setState(() {
                                                  _autoValidate = true;
                                                  err = false;
                                                });
                                              }
                                            },
                                            color: Colors.green,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        0.0)),
                                            child: Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Text(
                                                isConnected
                                                    ? "Submit Survey Report".toUpperCase()
                                                    : "Save Survey Report".toUpperCase(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: "Nunito",
                                                    fontSize: _large
                                                        ? kLargeFontSize
                                                        : (_medium
                                                            ? kMediumFontSize
                                                            : kSmallFontSize),
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                  ),
                              
                                 Center(
                                   child: FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        new FocusNode());
                                                setState(() {
                                                  _autoValidate = false;
                                                });
                                                _formKey.currentState.reset();
                                                
                                                _controller.clear();
                                                err=false;
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
                                                images.clear();
                                                markers.clear();
                                                redoStack.clear();
                                                othercommentController.clear();
                                                senderAddressController.clear();
                                                senderEmailController.clear();
                                                senderNameController.clear();
                                                senderPhoneController.clear();
                                                recieverNameController.clear();
                                                recieverPhoneController.clear();
                                                recieverEmailController.clear();
                                                recieverAddressController.clear();
                                                 controller.jumpTo(controller.position.minScrollExtent);
                                                  jobRefNode.requestFocus();
                                              });
                                            },
                                            
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        0.0)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Text(
                                                "Reset Survey",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: _large
                                                        ? kLargeFontSize
                                                        : (_medium
                                                            ? kMediumFontSize
                                                            : kSmallFontSize),
                                                    color: kPrimaryColor,
                                                    fontWeight: FontWeight.normal,
                                                    fontFamily: "Nunito"),
                                              ),
                                            ),
                                          ),
                                 )
                                
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Color(0xffb0b0b0)),
    );
  }

  takescrshot() async {
    RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
    var image = await boundary.toImage(pixelRatio: 3);
    var byteData = await image.toByteData(format: UI.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    base64Imagecar = base64Encode(pngBytes);
  
  }

  takescrshot1() async {
    RenderRepaintBoundary boundary = scr1.currentContext.findRenderObject();
    var image = await boundary.toImage(
        pixelRatio: MediaQuery.of(context).size.width / 250);
    var byteData = await image.toByteData(format: UI.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    base64Imageboat = base64Encode(pngBytes);

  }

  takescrshotrecieverSign() async {
    RenderRepaintBoundary boundary = scr2.currentContext.findRenderObject();
    var image = await boundary.toImage(pixelRatio: 4.5);
    var byteData = await image.toByteData(format: UI.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    base64Imagerecieversign = base64Encode(pngBytes);

  }

  takescrshotsenderSign() async {
    RenderRepaintBoundary boundary = scr3.currentContext.findRenderObject();
    var image = await boundary.toImage(pixelRatio: 4.5);
    var byteData = await image.toByteData(format: UI.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    base64Imagesendersign = base64Encode(pngBytes);
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
