import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/util/widget_utils.dart';

import '../main.dart';

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
      appBar: appBar(context, app_name, true, [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Tooltip(
            message: strings.account,
            child: RawMaterialButton(
              shape: CircleBorder(),
              onPressed: () => print('pressed'),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: Image.network(firebaseUser.photoURL)),
            ),
          ),
        )
      ]),
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
