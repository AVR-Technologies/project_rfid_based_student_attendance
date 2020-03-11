import 'package:flutter/material.dart';
import 'login_page.dart';

void main() => runApp(MaterialApp(
  home: LoginPage(),
  theme: ThemeData(
    primaryColor: Colors.blueGrey[700],
    accentColor: Colors.orange[700],
  ),
  title: 'My kid',),);
