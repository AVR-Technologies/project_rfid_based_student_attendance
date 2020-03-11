import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mykid/activities_page.dart';
import 'login_page.dart';

import 'services.dart';

class RegisterPage extends StatefulWidget{
  @override _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = new TextEditingController();
  final emailController = new TextEditingController();
  final mobileController = new TextEditingController();
  final studentIdController = new TextEditingController();
  final passwordController = new TextEditingController();
  final scaffoldKey        = new GlobalKey<ScaffoldState>();
  @override Widget build(BuildContext context) => Scaffold(
    key: scaffoldKey,
    appBar: AppBar(
      title: Text('Register'),
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
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'email',
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: mobileController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            maxLength: 10,
            decoration: InputDecoration(
              labelText: 'Mobile no',
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: studentIdController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            maxLength: 2,
            decoration: InputDecoration(
              labelText: 'Student id',
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
            child: Text('Register'),
            color: Colors.blueGrey[700],
            textColor: Colors.white,
            onPressed: register,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
            child: Text('Login instead'),
            onPressed: goToLoginPage,
          ),
        ),
      ],
    ),
  );

  goToLoginPage() => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),),);
  goToStudentLogsPage() => Navigator.push(context, MaterialPageRoute(builder: (context) => ActivitiesPage(studentId: studentIdController.text,),),);

  register() => usernameController.text.isNotEmpty  &&
                emailController.text.isNotEmpty     &&
                mobileController.text.isNotEmpty    &&
                studentIdController.text.isNotEmpty &&
                passwordController.text.isNotEmpty  ?
  RegisterHandler().
  register(username: usernameController.text, email: emailController.text, mobile: mobileController.text, studentId: studentIdController.text, password: passwordController.text).
  then((result) => result['success'] ? goToStudentLogsPage() : showMessage(result['message'])) :
  showMessage('All data necessary');

  showMessage(String message) => scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message ?? 'hi'),));
}

