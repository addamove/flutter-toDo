import 'package:flutter/material.dart';

import './toDo.dart';
import './login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDongle',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        primaryIconTheme: new IconThemeData(color: Colors.black),
        buttonColor: Colors.deepPurple,
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.deepPurpleAccent,
            textTheme: ButtonTextTheme.primary),
        accentColor: Colors.deepPurpleAccent,
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => ToDo(title: 'ToDongle'),
        '/login': (context) => Login(),
      },
    );
  }
}
