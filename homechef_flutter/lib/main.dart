import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:homechefflutter/models/User.dart';

import 'package:homechefflutter/screens/login_screen.dart';
import 'package:homechefflutter/utils/Globals.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main () {
  runApp(MyApp());
  Globals.getVersion();
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Widget app = MaterialApp(
      title: 'HomeChef Chef App',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: 'Open Sans',
          textTheme: TextTheme(
            headline1: TextStyle(
                fontFamily: 'Open Sans', fontSize: 18.0, fontWeight: FontWeight.w600, color: Color(
                0xFF656565)
            ),
            headline2: TextStyle(
                fontFamily: 'Open Sans', fontSize: 32.0, fontWeight: FontWeight.bold, color: Color(0XFF758E9A)
            ),
          )
      ),
      home: LoginScreen(),
    );

    return ChangeNotifierProvider(
      create: (context) => new User("", "", "", "", "", "",""),
      child: app,
    );
  }
}






