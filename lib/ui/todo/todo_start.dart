import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  bool loggedInWithGoogle = false;

  @override
  Widget build(BuildContext context) {
    loggedInWithGoogle = widget.firebaseUser.photoURL != null;

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
                    ),
                  ),
                  !loggedInWithGoogle
                      ? null
                      : PopupMenuItem<_PopupMenuAccount>(
                          value: _PopupMenuAccount.changeEmail,
                          child: Text(
                            strings.change_email,
                          ),
                        ),
                  !loggedInWithGoogle
                      ? null
                      : PopupMenuItem<_PopupMenuAccount>(
                          value: _PopupMenuAccount.changePassword,
                          child: Text(
                            strings.reset_password,
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
                      logOut();
                      break;
                    case _PopupMenuAccount.changeEmail:
                      changeEmail();
                      break;
                    case _PopupMenuAccount.changePassword:
                      changePassword();
                      break;
                    case _PopupMenuAccount.deleteAccount:
                      deleteAccount();
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
                ? widget.firebaseUser.email
                : widget.firebaseUser.displayName,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white54,
              ),
              onPressed: addTodoProject,
            ),
          )
        ],
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

  void logOut([bool deleted = false]) async {
    if (!deleted) await widget.firebaseAuth.signOut();
    Navigator.pushReplacement(context,
        MaterialPageRoute<void>(builder: (_) => MyHomePageAfterLoading()));
  }

  void changeEmail() {
    showAnimatedDialog(context,
        title: strings.change_email,
        inputFields: 2,
        inputFieldsHints: [strings.confirm_password, strings.new_email],
        inputTypes: [TextInputType.visiblePassword, TextInputType.emailAddress],
        onDone: (value) async {
      //re-authenticate needed to change the email, check the email
      try {
        UserCredential userCredential = await widget.firebaseAuth
            .signInWithEmailAndPassword(
                email: widget.firebaseUser.email, password: value[0]);

        if (userCredential == null) {
          showSnackBar(strings.wrong_password);
          return;
        }

        //now check entered email
        if ((await EMAIL_REGEX).hasMatch(value[1])) {
          widget.firebaseUser.updateEmail(value[1]);
          showSnackBar(strings.email_changed);
        } else
          showSnackBar(strings.bad_email);
      } catch (e) {
        showSnackBar(strings.wrong_password);
        return;
      }
    });
  }

  void showSnackBar(String msg) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
  }

  void changePassword() {
    showAnimatedDialog(context,
        title: strings.reset_password,
        inputFields: 2,
        inputFieldsHints: [
          strings.confirm_password,
          strings.new_password
        ],
        inputTypes: [
          TextInputType.visiblePassword,
          TextInputType.visiblePassword
        ], onDone: (value) async {
      //re-authenticate needed to change the email, check the email
      try {
        UserCredential userCredential = await widget.firebaseAuth
            .signInWithEmailAndPassword(
                email: widget.firebaseUser.email, password: value[0]);

        if (userCredential == null) {
          showSnackBar(strings.wrong_password);
          return;
        }

        //now check entered new password
        if (passwordValidates(value[1])) {
          widget.firebaseUser.updatePassword(value[1]);
          showSnackBar(strings.password_changed);
        } else
          showSnackBar(strings.login_bad_password);
      } catch (e) {
        showSnackBar(strings.wrong_password);
        return;
      }
    });
  }

  void deleteAccount() {
    showAnimatedDialog(context,
        title: strings.delete_account_title,
        text: strings.delete_account_text,
        inputFields: loggedInWithGoogle ? 0 : 1,
        inputTypes: [TextInputType.visiblePassword],
        inputFieldsHints: [strings.confirm_password],
        warningOnDoneButton: true, onDone: (value) async {
      if (loggedInWithGoogle) {
        //make sure that logged in with google properly to re-authenticate
        final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential user =
            await widget.firebaseAuth.signInWithCredential(credential);
        assert(user.user.email != null);
        assert(user.user.displayName != null);
        assert(!user.user.isAnonymous);
        assert(await user.user.getIdToken() != null);

        final User currentUser = widget.firebaseAuth.currentUser;
        assert(currentUser.uid == currentUser.uid);

        //delete the account
        widget.firebaseUser.delete().then((value) {
          //when deleted, log off
          logOut(true);
        });
      } else {
        //re-authenticate needed to change the email, check the email
        try {
          UserCredential userCredential = await widget.firebaseAuth
              .signInWithEmailAndPassword(
                  email: widget.firebaseUser.email, password: value[0]);

          if (userCredential == null) {
            showSnackBar(strings.wrong_password);
            return;
          }

          //delete the account
          widget.firebaseUser.delete().then((value) {
            //when deleted, log off
            logOut(true);
          });
        } catch (e) {
          showSnackBar(strings.wrong_password);
          return;
        }
      }
    });
  }

  void addTodoProject() {
    
  }
}
