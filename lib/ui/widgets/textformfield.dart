import 'package:flutter/material.dart';
import 'package:flutter_app/constants/constants.dart';
import 'package:flutter_app/ui/widgets/responsive_ui.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  double _width;
  double _pixelRatio;
  bool large;
  bool medium;


  CustomTextField(
    {this.hint,
      this.textEditingController,
      this.keyboardType,
      this.icon,
      this.obscureText= false,
     });

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium=  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: large? 12 : (medium? 10 : 8),
      child: TextFormField(
        obscureText: obscureText,
        controller: textEditingController,
        style: TextStyle(fontFamily: "Nunito",fontSize: large ? kLargeFontSize : (medium ? kMediumFontSize : kSmallFontSize)),
        keyboardType: keyboardType,
        cursorColor: Color(0xff0985ba),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xff1a6ea8), size: large ? kLargeFontSize : (medium ? kMediumFontSize : kSmallFontSize)),
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
