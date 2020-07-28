import 'dart:ui';

import 'package:flutter/material.dart';

class CarSurveyPainter extends CustomPainter {
  //2
  CarSurveyPainter({@required this.markers});

  //3
  final List<Map<String,dynamic>> markers;

  //4
  @override
  void paint(Canvas canvas, Size size) {
    TextStyle textStyle = TextStyle(
    color: Colors.red,
    fontSize: 28,
    fontWeight: FontWeight.bold
  );
  if(markers.isNotEmpty)
  for(Map marker in markers)
    {
      TextPainter textPainter=TextPainter(text: TextSpan(
    text: marker['text'],
    style: textStyle,
  ),
    textDirection: TextDirection.ltr,);
    textPainter.layout(
    minWidth: 0,
    maxWidth: size.width,
  );
    textPainter.paint(canvas, Offset(marker['offset'].dx-10,marker['offset'].dy-12.35));}
  }
  

  //5
  @override
  bool shouldRepaint(CarSurveyPainter oldDelegate) {
    return true;
  }
}