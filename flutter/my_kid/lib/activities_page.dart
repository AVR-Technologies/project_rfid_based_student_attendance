import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:mykid/services.dart';


class ActivitiesPage extends StatefulWidget{
  final String studentId;
  const ActivitiesPage({Key key, this.studentId}) : super(key: key);
  @override  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final                           scaffoldKey                     = new GlobalKey<ScaffoldState>();
  List<StudentLog>                studentLogs                     = new List();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Timer                           timer;

  @override void dispose() {
    timer.cancel();
    super.dispose();
  }
  @override void initState() {
    super.initState();
    initNotificationChannel();
    print(widget.studentId);
    startFetching();
  }

  @override  Widget build(BuildContext context) => Scaffold(
    key: scaffoldKey,
    appBar: AppBar(
      title: Text('Activities'),
    ),
    body: ListView.builder(
      itemCount: studentLogs.length,
      itemBuilder: (context, index) => ListTile(
        leading: Icon(studentLogs[index].busOrSchool ? Icons.directions_bus : Icons.school),
        title: Text(StudentLog.position(studentLogs[index])),
        subtitle: Text('on ${DateFormat('hh:mm, dd MMM, yyyy').format(DateTime.parse(studentLogs[index].logTime))}'),
        onTap: () => onSelectNotification(json.encode(studentLogs[index].toMap())),
        trailing: Icon(studentLogs[index].inOrOut ? Icons.call_received : Icons.call_made),
      ),
    ),
  );

  initNotificationChannel(){
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }


  startFetching() => timer =
      Timer.
      periodic(Duration(seconds: 1), (_timer) => LogsHandler().
      fetch(studentId: widget.studentId).
      then((result) {
        if(result['success']) setState(() {
          studentLogs.clear();
          studentLogs = (result['logs'] as List).map((item) {
            if (StudentLog.fromDynamic(item).isNewEntry) showNotification(StudentLog.fromDynamic(item));
            return StudentLog.fromDynamic(item);
          }).toList();
        });
        else {
          scaffoldKey.currentState.removeCurrentSnackBar();
          showMessage(result['message']);
        }
      }));


  showMessage(String message) => scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message ?? 'hi'),));

  showNotification(StudentLog studentLog) async {
    var android = new AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channel description',
        importance: Importance.Max,
        priority: Priority.High);
    var iOS     = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.
    show(
        0,
        StudentLog.position(studentLog),
        'on ${DateFormat('hh:mm, dd MMM, yyyy').format(DateTime.parse(studentLog.logTime))}',
        platform,
        payload: json.encode(studentLog.toMap()));
  }

  Future onSelectNotification(String payload) => showDialog(context: context, builder: (context) => new AlertDialog(
    title:   new Text(StudentLog.position(StudentLog.fromDynamic(json.decode(payload)))),
    content: new Text('on ${DateFormat('hh:mm, dd MMM, yyyy').format(DateTime.parse(StudentLog.fromDynamic(json.decode(payload)).logTime))}'),
    actions: <Widget>[
      FlatButton(
        child: Text('Close'),
        onPressed: () => Navigator.pop(context),
      )
    ],
  ),);
}
class StudentLog {
  final String id;
  final String studentId;
  final String logTime;
  final bool inOrOut;       // in       = 1, out  = 0
  final bool busOrSchool;   // bus      = 1, out  = 0
  final bool isNewEntry;    // newEntry = 1, else = 0
  StudentLog(this.id, this.studentId, this.logTime, this.inOrOut, this.busOrSchool, this.isNewEntry);
  toMap() => {
    'id'            : this.id,
    'student_id'    : this.studentId,
    'log_time'      : this.logTime,
    'in_out'        : boolToInt(this.inOrOut).toString(),
    'bus_school'    : boolToInt(this.busOrSchool).toString(),
    'is_new_entry'  : boolToInt(this.isNewEntry).toString(),
  };
  StudentLog.fromDynamic(dynamic map) :
        this.id        = map['id'],
        this.studentId = map['student_id'],
        this.logTime   = map['log_time'],
        this.inOrOut     = intToBool(int.parse(map['in_out'])),
        this.busOrSchool = intToBool(int.parse(map['bus_school'])),
        this.isNewEntry  = intToBool(int.parse(map['is_new_entry']));
  static int boolToInt(bool val) => val ? 1 : 0;
  static bool intToBool(int val) => val == 1;
  static String position(StudentLog log) =>
      !log.inOrOut && log.busOrSchool  ? 'Enterred in bus'     :
      log.inOrOut  && log.busOrSchool  ? 'Out of bus'          :
      !log.inOrOut && !log.busOrSchool ? 'Enterred in school'  :
      log.inOrOut  && !log.busOrSchool ? 'Out of school'       : 'Unknown situation';
}

