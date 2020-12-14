import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/main.dart';

import 'logged_in_page.dart';

class EmailPage extends StatefulWidget {
  final FirebaseAuth firebaseAuth;

  const EmailPage({Key key, @required this.firebaseAuth}) : super(key: key);

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _success;
  String _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.login_sign_in_with_email),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: strings.login_email),
                validator: (String value) {
                  return value.isEmpty
                      ? strings.login_please_enter_email
                      : null;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: strings.login_password),
                obscureText: true,
                validator: (String value) {
                  return value.isEmpty ? strings.login_enter_password : null;
                },
              ),
            ),
            Container(
                alignment: Alignment.center,
                child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text(strings.login_register),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _createAccountWithEmailAndPassword();
                        }
                      },
                    ),
                    RaisedButton(
                        child: Text(strings.login_login),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _signInWithEmailAndPassword();
                          }
                        })
                  ],
                )),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _success == null
                    ? ''
                    : strings.login_sign_in_failed(_errorMessage),
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmailAndPassword() async {
    final UserCredential user =
        await widget.firebaseAuth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (user != null) {
      setState(() {
        _success = true;
      });
      Future.microtask(() => Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (_) => LoggedInPage(
                  firebaseAuth: widget.firebaseAuth,
                  firebaseUser: user.user))));
    } else {
      _success = false;
    }
  }

  bool _passwordValidates(String pass) {
    int count = 0;

    if (8 <= pass.length && pass.length <= 32) {
      if (RegExp(".*\\d.*").hasMatch(pass)) count++;
      if (RegExp(".*[a-z].*").hasMatch(pass)) count++;
      if (RegExp(".*[A-Z].*").hasMatch(pass)) count++;
      if (RegExp('^.*[*.!@#\$%^&(){}[]:\";\'<>,.?/~`_+-=|\\].*\$')
          .hasMatch(pass)) count++;
    }

    return count >= 3;
  }

  void _createAccountWithEmailAndPassword() async {
    //check password
    if (!_passwordValidates(_passwordController.text)) {
      _success = false;
      _errorMessage = strings.login_bad_password;
      return;
    }

    //login with credentials
    try {
      final UserCredential user = await widget.firebaseAuth
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      if (user != null) {
        setState(() {
          _success = true;
        });
        Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (_) => LoggedInPage(
                    firebaseAuth: widget.firebaseAuth,
                    firebaseUser: user.user)));
      }
    } on PlatformException catch (e) {
      setState(() {
        _success = false;
        _errorMessage = e.message;
      });
    }
  }
}