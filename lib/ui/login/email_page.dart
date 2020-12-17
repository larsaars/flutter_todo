import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/main.dart';
import 'package:todo/ui/widget/standard_widgets.dart';
import 'package:todo/util/utils.dart';
import 'package:todo/util/widget_utils.dart';

import '../todo/todo_start.dart';

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
      appBar: appBar(context, strings.login_sign_in_with_email),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
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
                    StandardFlatButton(
                      text: strings.login_register,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _createAccountWithEmailAndPassword();
                        }
                      },
                    ),
                    StandardFilledButton(
                      text: strings.login_login,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _signInWithEmailAndPassword();
                        }
                      },
                    ),
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
    UserCredential user;

    try {
      user = await widget.firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (e) {
      setState(() {
        _success = false;
        _errorMessage = (e as FirebaseException).message;
      });
    }

    if (user != null) {
      setState(() {
        _success = true;
      });

      Future.microtask(() => Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
              builder: (_) => TodoStartPage(
                  firebaseAuth: widget.firebaseAuth,
                  firebaseUser: user.user))));
    } else {
      _success = false;
    }
  }

  void _createAccountWithEmailAndPassword() async {
    //check email
    if (!(await EMAIL_REGEX).hasMatch(_emailController.text)) {
      setState(() {
        _success = false;
        _errorMessage = strings.bad_email;
      });
      return;
    }
    //check password
    if (!passwordValidates(_passwordController.text)) {
      setState(() {
        _success = false;
        _errorMessage = strings.login_bad_password;
      });
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
                builder: (_) => TodoStartPage(
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
