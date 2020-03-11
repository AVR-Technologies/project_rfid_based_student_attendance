import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mykid/strings.dart';

class LoginHandler {
  Future<dynamic> login({@required String username, @required String password }) async =>
      json.decode((await http.get(Strings.login_url + withUsername(username) + withPassword(password))).body);
  String withUsername(String username) => 'username=$username&';
  String withPassword(String password) => 'password=$password';
}

class RegisterHandler {
  Future<dynamic> register({@required String username, @required String email, @required String mobile, @required String studentId, @required String password }) async =>
      json.decode((await http.get(Strings.register_url + withUsername(username) + withEmail(email) +withMobile(mobile) + withStudentId(studentId)+ withPassword(password))).body);
  String withUsername(String username)    => 'username=$username&';
  String withEmail(String email)          => 'email=$email&';
  String withMobile(String mobile)        => 'mobile=$mobile&';
  String withStudentId(String studentId)  => 'student_id=$studentId&';
  String withPassword(String password)    => 'password=$password';
}


class LogsHandler {
  Future<dynamic> fetch({@required String studentId}) async =>
      json.decode((await http.get(Strings.students_logs_url + withStudentId(studentId))).body);
  String withStudentId(String studentId) => 'student_id=$studentId';
}