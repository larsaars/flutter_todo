import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/util/widget_utils.dart';

class TodoStartPage extends StatelessWidget {
  final User firebaseUser;
  final FirebaseAuth firebaseAuth;

  const TodoStartPage({
    Key key,
    @required this.firebaseUser,
    @required this.firebaseAuth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'logged in', true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Signed in as: ${firebaseUser.email}'),
            RaisedButton(
              child: Text('Sign out'),
              onPressed: () async {
                await firebaseAuth.signOut();
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
