import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

// TODO class

class Login extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

// Example code of how to sign in anonymously.
  void _signInAnonymously() async {
    final FirebaseUser user = await _auth.signInAnonymously();
    assert(user != null);
    assert(user.isAnonymous);
    assert(!user.isEmailVerified);
    assert(await user.getIdToken() != null);
    if (Platform.isIOS) {
      // Anonymous auth doesn't show up as a provider on iOS
      assert(user.providerData.isEmpty);
    } else if (Platform.isAndroid) {
      // Anonymous auth does show up as a provider on Android
      assert(user.providerData.length == 1);
      assert(user.providerData[0].providerId == 'firebase');
      assert(user.providerData[0].uid != null);
      assert(user.providerData[0].displayName == null);
      assert(user.providerData[0].photoUrl == null);
      assert(user.providerData[0].email == null);
    }

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    print(user);
  }

  // Example code of how to sign in with email and password.
  void _signInWithEmailAndPassword() async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    // if (user != null) {
    //   setState(() {
    //     _success = true;
    //     _userEmail = user.email;
    //   });
    // } else {
    //   _success = false;
    // }
  }

  void _handleRegister() async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: 'addamove@gmail.com',
      password: '12345678',
    );
    print(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material App Bar'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Email'),
            TextField(),
            Text('Password'),
            TextField(),
            FlatButton(
              child: Text('Login'),
              onPressed: () async {
                _signInWithEmailAndPassword();
              },
            ),
            FlatButton(
              child: Text('Registrer'),
              onPressed: () {
                _handleRegister();
              },
            ),
          ],
        ),
      ),
    );
  }
}
