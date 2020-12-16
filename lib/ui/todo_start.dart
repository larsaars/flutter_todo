import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

enum _PopupMenuAccount { logOff, changePassword, changeEmail, deleteAccount }

class TodoStartPage extends StatefulWidget {
  final User firebaseUser;
  final FirebaseAuth firebaseAuth;

  TodoStartPage({
    Key key,
    @required this.firebaseUser,
    @required this.firebaseAuth,
  }) : super(key: key);

  @override
  _TodoStartPageState createState() => _TodoStartPageState();
}

class _TodoStartPageState extends State<TodoStartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Material(
              color: Colors.transparent,
              child: PopupMenuButton(
                tooltip: strings.account,
                child: widget.firebaseUser.photoURL == null
                    ? Image.asset('res/drawable/profile.png')
                    : Image.network(widget.firebaseUser.photoURL),
                itemBuilder: (context) => <PopupMenuEntry<_PopupMenuAccount>>[
                  PopupMenuItem<_PopupMenuAccount>(
                    value: _PopupMenuAccount.logOff,
                    child: Text(
                      strings.log_off,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  PopupMenuItem<_PopupMenuAccount>(
                    value: _PopupMenuAccount.changeEmail,
                    child: Text(
                      strings.change_email,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  PopupMenuItem<_PopupMenuAccount>(
                    value: _PopupMenuAccount.changePassword,
                    child: Text(
                      strings.reset_password,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  PopupMenuItem<_PopupMenuAccount>(
                    value: _PopupMenuAccount.deleteAccount,
                    child: Text(
                      strings.delete_account,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.red),
                    ),
                  )
                ],
                onSelected: (value) {},
              ),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
            widget.firebaseUser.displayName == null
                ? app_name
                : widget.firebaseUser.displayName,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Signed in as: ${widget.firebaseUser.email}'),
            RaisedButton(
              child: Text('Sign out'),
              onPressed: () {
                _logOut(context);
              },
            )
          ],
        ),
      ),
    );
  }

  void _logOut(BuildContext context) async {
    await widget.firebaseAuth.signOut();
    Navigator.pushReplacement(context,
        MaterialPageRoute<void>(builder: (_) => MyHomePageAfterLoading()));
  }
}
