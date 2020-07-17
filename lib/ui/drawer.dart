import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DrawerList {
  final IconData icon;
  final Text text;
  final int id;
  final String widgeturl;
  DrawerList({this.icon, this.text, this.id,this.widgeturl});
}



List<DrawerList> drawerlist = <DrawerList>[
//  DrawerList(  icon: Icons.home, text:  Text("Dashboard",
//      style: TextStyle(
//          fontSize: 20,
//          fontFamily: "AVENIRLTSTD",
//          // fontWeight: FontWeight.bold,
//          color: Color(0xff222222))),id:0,),
//  DrawerList(
//      icon: Icons.call, text:  Text("Support",
//      style: TextStyle(
//          fontSize: 20,
//          fontFamily: "AVENIRLTSTD",
//          // fontWeight: FontWeight.bold,
//          color: Color(0xff222222))), ),
//
//
//  DrawerList(
//      id:9,
//      icon: Icons.history,
//      text:  Text("History",
//          style: TextStyle(
//              fontSize: 20,
//              fontFamily: "AVENIRLTSTD",
//              // fontWeight: FontWeight.bold,
//              color: Color(0xff222222))),
//     ),
//  DrawerList(
//      id:10,
//      icon: Icons.add_box,
//      text:  Text("About",
//          style: TextStyle(
//              fontSize: 20,
//              fontFamily: "AVENIRLTSTD",
//              // fontWeight: FontWeight.bold,
//              color: Color(0xff222222))),
//     ),
  DrawerList(
      id:11,
      icon: Icons.exit_to_app,
      text:  Text("Log Out",
          style: TextStyle(
              fontSize: 20,
              fontFamily: "AVENIRLTSTD",
              // fontWeight: FontWeight.bold,
              color: Color(0xff222222))),
      ),

  // DrawerList(icon: Icons.list, text: "Enquiry List", widgeturl: "Home"),
  DrawerList(         icon: Icons.input, text: Text("Log Out",
      style: TextStyle(
          fontSize: 20,
          fontFamily: "AVENIRLTSTD",
          // fontWeight: FontWeight.bold,
          color: Color(0xff222222))), widgeturl: "",  id:13,)
];
Widget drawerData(BuildContext context) {

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        SizedBox(height: 35,),

        // textLabel(user.name ?? ""),
        Container(
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height * 2 / 3,
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,

            children: <Widget>[
              ListTile(
                  leading: Icon(drawerlist[0].icon),
                  title: drawerlist[0].text,
                  onTap: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.remove("loggedIn");
                    Navigator.of(context).pushNamedAndRemoveUntil(SIGN_IN, (Route<dynamic> route) => false);
                  }
              ),
//              ListTile(
//                  leading: Icon(drawerlist[1].icon),
//                  title: drawerlist[1].text,
//                  onTap: () {
//
//                  }
//              ),
//
//              ListTile(
//                  leading: Icon(drawerlist[2].icon),
//                  title: drawerlist[2].text,
//                  onTap: () {
//
//                  }
//                  ),
//
//              ListTile(
//                  leading: Icon(drawerlist[3].icon),
//                  title: drawerlist[3].text,
//                  onTap: () {
//
//                  }),
//
//              ListTile(
//                  leading: Icon(drawerlist[4].icon),
//                  title: drawerlist[4].text,
//                  onTap: () async {
//                    SharedPreferences prefs = await SharedPreferences.getInstance();
//                    //Remove String
//                    prefs.remove("loggedIn");
//                    Navigator.of(context).pushNamedAndRemoveUntil(SIGN_IN, (Route<dynamic> route) => false);
//                  }),


            ],
          ),
        ),
      ],
    ),
    //   )
    // ],
    // ),
  );
}
