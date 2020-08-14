// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.status,
    this.token,
    this.username,
    this.id
  });

  String status;
  int id;
  String token;
  String username;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"],
    token: json["token"],
    username: json["status"]!='success'?"":json['user_data']['name'],
    id:json["status"]!='success'?"":json['user_data']['id']
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "token": token,
  };
}
