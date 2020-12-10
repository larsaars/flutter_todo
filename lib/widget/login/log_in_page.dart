import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'email_page.dart';
import 'logged_in_page.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class LogInPage extends StatefulWidget {
  final String title;

  LogInPage({Key key, this.title}) : super(key: key);

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
          LoggedInPage(firebaseAuth: _auth, firebaseUser: _auth.currentUser));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton.icon(
              color: Colors.white,
              icon: Image.asset(
                'res/drawable/google.png',
                width: 24,
                height: 24,
              ),
              label: Text('Sign in with Google'),
              onPressed: () {
                _signInWithGoogle();
              },
            ),
            RaisedButton.icon(
              color: Colors.white,
              icon: Icon(Icons.email),
              label: Text('Sign in with email'),
              onPressed: () {
                _pushPage(context, EmailPage(firebaseAuth: _auth));
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
          context, LoggedInPage(firebaseAuth: _auth, firebaseUser: user.user));
    }
  }
}

// Helper method to navigate pages
void _pushPage(BuildContext context, Widget page) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => page),
  );
}
