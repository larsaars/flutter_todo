import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/ui/widget/standard_widgets.dart';
import 'package:todo/util/utils.dart';
import 'package:todo/util/widget_utils.dart';

import '../../main.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Material(
              color: Colors.transparent,
              child: PopupMenuButton(
                tooltip: strings.account,
                child: isEmpty(widget.firebaseUser.photoURL)
                    ? StandardIcon(Icons.person)
                    : Image.network(widget.firebaseUser.photoURL),
                itemBuilder: (context) =>
                    makeNonNull(<PopupMenuEntry<_PopupMenuAccount>>[
                  PopupMenuItem<_PopupMenuAccount>(
                    value: _PopupMenuAccount.logOff,
                    child: Text(
                      strings.log_off,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  widget.firebaseUser.photoURL != null
                      ? null
                      : PopupMenuItem<_PopupMenuAccount>(
                          value: _PopupMenuAccount.changeEmail,
                          child: Text(
                            strings.change_email,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                  widget.firebaseUser.photoURL != null
                      ? null
                      : PopupMenuItem<_PopupMenuAccount>(
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
                ]),
                onSelected: (value) {
                  switch (value) {
                    case _PopupMenuAccount.logOff:
                      _logOut(context);
                      break;
                    case _PopupMenuAccount.changeEmail:
                      _changeEmail();
                      break;
                    case _PopupMenuAccount.changePassword:
                      _changePassword();
                      break;
                    case _PopupMenuAccount.deleteAccount:
                      _deleteAccount();
                      break;
                    default:
                      break;
                  }
                },
              ),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
            isEmpty(widget.firebaseUser.displayName)
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
            //projects
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

  void _changeEmail() {
    showAnimatedDialog(context, inputFields: 2,
        inputFieldsHints: [strings.login_password, strings.new_email],
        inputTypes: [TextInputType.visiblePassword, TextInputType.emailAddress],
        onDone: (value) async {
      //re-authenticate needed to change the email, check the email
      UserCredential userCredential = await widget.firebaseAuth.signInWithEmailAndPassword(email: widget.firebaseUser.email, password: value[0]);
      if ((await EMAIL_REGEX).hasMatch(value))
        widget.firebaseUser.updateEmail(value);
      else
        showSnackBar(strings.login_bad_password);
    });
  }

  void showSnackBar(String msg) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
  }

  void _changePassword() {
    showAnimatedDialog(
      context,
      title: strings.reset_password,
    );
  }

  void _deleteAccount() {}
}
