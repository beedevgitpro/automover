// To parse this JSON data, do
//
//     final carCrashModel = carCrashModelFromJson(jsonString);

import 'dart:convert';

CarCrashModel carCrashModelFromJson(String str) => CarCrashModel.fromJson(json.decode(str));

String carCrashModelToJson(CarCrashModel data) => json.encode(data.toJson());

class CarCrashModel {
  CarCrashModel({
    this.status,
  });

  String status;

  factory CarCrashModel.fromJson(Map<String, dynamic> json) => CarCrashModel(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
