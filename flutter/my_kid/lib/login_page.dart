import 'package:flutter/material.dart';
import 'package:mykid/activities_page.dart';
import 'register_page.dart';
import 'services.dart';

class LoginPage extends StatefulWidget{
  @override _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();
  final scaffoldKey        = new GlobalKey<ScaffoldState>();
  @override Widget build(BuildContext context) => Scaffold(
    key: scaffoldKey,
    appBar: AppBar(
      title: Text('Login'),
    ),
    body: ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'password',
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
            child: Text('Login'),
            color: Colors.blueGrey[700],
            textColor: Colors.white,
            onPressed: login,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
            child: Text('Register instead'),
            onPressed: goToRegisterPage,
          ),
        ),
      ],
    ),
  );
  goToRegisterPage() => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage(),),);
  goToStudentLogsPage(String studentId) => Navigator.push(context, MaterialPageRoute(builder: (context) => ActivitiesPage(studentId: studentId,),),);

  login() => usernameController.text.isNotEmpty  &&
      passwordController.text.isNotEmpty  ?
  LoginHandler().
  login(username: usernameController.text, password: passwordController.text).
  then((result) => result['success'] ? goToStudentLogsPage(result['data'][0]['student_id']) : showMessage(result['message'])) :
  showMessage('All data necessary');

  showMessage(String message) => scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message ?? 'hi'),));
}

