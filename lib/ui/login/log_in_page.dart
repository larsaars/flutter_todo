import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/main.dart';
import 'package:todo/ui/style.dart';
import 'package:todo/util/widget_utils.dart';

import '../todo/todo_start.dart';
import 'email_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class LogInPage extends StatefulWidget {
  final String title;

  LogInPage({
    Key key,
    this.title = 'login',
  }) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  void initState() {
    super.initState();
    // Enabled persistent log-ins by checking the Firebase Auth instance for previously logged in users
    if (_auth.currentUser != null) {
      _pushPage(context,
          TodoStartPage(firebaseAuth: _auth, firebaseUser: _auth.currentUser));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, widget.title, true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton.icon(
              color: Styles.white54IconColor,
              icon: Image.asset(
                'res/drawable/google.png',
                width: 24,
                height: 24,
              ),
              label: Text(strings.login_sign_in_with_google),
              onPressed: () {
                _signInWithGoogle();
              },
            ),
            RaisedButton.icon(
              color: Styles.white54IconColor,
              icon: Icon(Icons.email),
              label: Text(strings.login_sign_in_with_email),
              onPressed: () {
                Future.microtask(
                    () => Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (_) => EmailPage(firebaseAuth: _auth),
                        )));
              },
            )
          ],
        ),
      ),
    );
  }

  void _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential user = await _auth.signInWithCredential(credential);
    assert(user.user.email != null);
    assert(user.user.displayName != null);
    assert(!user.user.isAnonymous);
    assert(await user.user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(currentUser.uid == currentUser.uid);
    if (user != null) {
      _pushPage(
          context, TodoStartPage(firebaseAuth: _auth, firebaseUser: user.user));
    }
  }
}

// Helper method to navigate pages
void _pushPage(BuildContext context, Widget page) {
  Future.microtask(() => Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => page),
      ));
}
