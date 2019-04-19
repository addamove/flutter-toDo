import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './toDo.dart';
import './login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget _handleCurrentScreen() {
    return new StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              return ToDo(
                  key: Key('123'), title: '123', uuid: snapshot.data.uid);
            }
            return Login();
          }
        });
  }

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
      home: _handleCurrentScreen(),
      routes: {
        '/login': (context) => Login(),
      },
    );
  }
}
