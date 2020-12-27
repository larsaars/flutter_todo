import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/holder/project.dart';
import 'package:todo/holder/todo.dart';
import 'package:todo/ui/todo/todo_project.dart';
import 'package:todo/ui/widget/standard_widgets.dart';
import 'package:todo/util/utils.dart';
import 'package:todo/util/widget_utils.dart';

import '../../main.dart';

enum _PopupMenuAccount {
  logOff,
  changePassword,
  changeEmail,
  deleteAccount,
  about
}

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
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool loggedInWithGoogle = false, searching = false;
  List<Project> projects = [], filteredProjects = [];
  TextEditingController searchController = TextEditingController();
  DocumentReference userDoc;
  SlidableController slidableController;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    //the slidable controller
    slidableController = SlidableController();
    //load google login bool
    loggedInWithGoogle = widget.firebaseUser.photoURL != null;
    //load the root user doc
    userDoc = firestore.collection('users').doc(widget.firebaseUser.uid);
    //load projects from firebase
    userDoc?.collection('pro')?.get()?.then((snapshot) {
      //set the state with future micro task
      setState(() {
        //set the data list
        projects = snapshot?.docs?.map((e) {
          var data = e.data();
          return Project(
            e.id,
            data['name'],
            data['lastAccessed'],
            data['itemCount'],
          );
        })?.toList();

        //copy filtered to projects
        filteredProjects = [...projects];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //before every build resort the lists
    sort();
    //then build the widget
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 170),
            transitionBuilder: (child, animation) => ScaleTransition(
              child: child,
              scale: animation,
            ),
            child: searching
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white54,
                    ),
                    onPressed: () => setState(() {
                          //not searching anymore
                          searching = false;
                          //also clear the search controller
                          searchController.clear();
                          //copy back the filtered items to normal
                          filteredProjects = [...projects];
                        }))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(45),
                    child: Material(
                      color: Colors.transparent,
                      child: PopupMenuButton(
                        tooltip: strings.account,
                        child: isEmpty(widget.firebaseUser.photoURL)
                            ? DefaultIcon(Icons.person)
                            : Image.network(widget.firebaseUser.photoURL),
                        itemBuilder: (context) =>
                            makeNonNull(<PopupMenuEntry<_PopupMenuAccount>>[
                          PopupMenuItem<_PopupMenuAccount>(
                            value: _PopupMenuAccount.about,
                            child: Text(
                              strings.about,
                            ),
                          ),
                          PopupMenuItem<_PopupMenuAccount>(
                            value: _PopupMenuAccount.logOff,
                            child: Text(
                              strings.log_off,
                            ),
                          ),
                          loggedInWithGoogle
                              ? null
                              : PopupMenuItem<_PopupMenuAccount>(
                                  value: _PopupMenuAccount.changeEmail,
                                  child: Text(
                                    strings.change_email,
                                  ),
                                ),
                          loggedInWithGoogle
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
                            case _PopupMenuAccount.about:
                              showAbout(context);
                              break;
                            default:
                              break;
                          }
                        },
                      ),
                    ),
                  ),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: AnimatedSwitcher(
          duration: Duration(milliseconds: 170),
          transitionBuilder: (child, animation) => ScaleTransition(
            child: child,
            scale: animation,
          ),
          child: searching
              ? Stack(alignment: Alignment.centerRight, children: [
                  Icon(
                    Icons.search,
                    color: Colors.white54,
                  ),
                  TextFormField(
                    textAlign: TextAlign.justify,
                    controller: searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.white),
                    autofocus: true,
                    onChanged: (value) => setState(() {
                      //filter the projects titles
                      if (value.isEmpty)
                        //clone the projects list
                        filteredProjects = [...projects];
                      else
                        filteredProjects = projects
                            .where((element) => element.name
                                .toLowerCase()
                                .contains(searchController.text.toLowerCase()))
                            .toList();
                    }),
                  ),
                ])
              : Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Text(
                          isEmpty(widget.firebaseUser.displayName)
                              ? widget.firebaseUser.email
                              : widget.firebaseUser.displayName,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .copyWith(color: Colors.white)),
                      Text(strings.projects,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Colors.white)),
                    ]),
        ),
        actions: <Widget>[
          Visibility(
            visible: !searching,
            child: Tooltip(
              message: strings.add_project,
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white54,
                ),
                onPressed: addTodoProject,
              ),
            ),
          ),
          Tooltip(
            message: searching ? strings.clear : strings.search,
            child: IconButton(
              icon: Icon(
                searching ? Icons.clear : Icons.search,
                color: Colors.white54,
              ),
              onPressed: () => setState(() {
                if (searching) {
                  //clear the search
                  searchController.clear();
                  //copy back the filtered items to normal
                  filteredProjects = [...projects];
                } else
                  searching = true;
              }),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredProjects.length,
        itemBuilder: (context, index) {
          Project item = filteredProjects[index];
          var key = Key(item.id ?? index.toString());
          return Card(
            key: Key(item.id ?? index.toString()),
            child: Slidable(
              key: key,
              controller: slidableController,
              actionExtentRatio: 0.25,
              direction: Axis.horizontal,
              actionPane: SlidableStrechActionPane(),
              dismissal: SlidableDismissal(
                  child: SlidableDrawerDismissal(),
                  dismissThresholds: <SlideActionType, double>{
                    SlideActionType.primary: 0.6,
                    SlideActionType.secondary: 1,
                  },
                  onDismissed: (actionType) {
                    if (actionType == SlideActionType.primary)
                      //could have new index if list changed, so get it newly
                      deleteItem(item);
                  }),
              child: ListTile(
                title: Text(
                  '${item.name}',
                ),
                subtitle: Text(
                  formatTime(context,
                      DateTime.fromMillisecondsSinceEpoch(item.lastAccessed)),
                ),
                onTap: () => tapListTile(item),
              ),
              actions: <Widget>[
                IconSlideAction(
                  caption: strings.delete,
                  color: Colors.red[800],
                  icon: Icons.delete,
                  onTap: () => deleteItem(item),
                ),
              ],
              secondaryActions: [
                IconSlideAction(
                  caption: strings.rename,
                  color: Colors.indigoAccent,
                  icon: Icons.drive_file_rename_outline,
                  onTap: () => renameItem(item),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void sort() {
    sort0(projects);
    sort0(filteredProjects);
  }

  void sort0(List<Project> pro) {
    pro.sort((a, b) => b.lastAccessed.compareTo(a.lastAccessed));
  }

  void renameItem(Project project) {
    showAnimatedDialog(context,
        title: strings.rename_project,
        inputFields: 1,
        inputFieldsHints: [
          strings.project_name
        ],
        inputTypes: [
          TextInputType.text
        ],
        inputValidators: [
          (value) => (isEmpty(value) ? null : strings.project_name)
        ], onDone: (value) {
      //rename the project in db
      userDoc
          .collection('pro')
          .doc(project.id)
          .update(<String, dynamic>{'name': value[0]});
      //new state
      setState(() {
        //edit the lists
        projects[projects.indexOf(project)].name = value[0];
        filteredProjects[filteredProjects.indexOf(project)].name = value[0];
      });
    });
  }

  void deleteItem(Project project) {
    //update the state
    setState(() {
      //remove project from both lists
      projects.remove(project);
      filteredProjects.remove(project);
    });
    //state of undone
    bool undone = false;
    //show a snackbar with undo button
    scaffoldKey.currentState
        .showSnackBar(SnackBar(
            content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(strings.deleted_project(project.name)),
            DefaultFlatButton(
                text: strings.undo,
                onPressed: () {
                  //close the snack bar
                  scaffoldKey.currentState.hideCurrentSnackBar();
                  //has been undone
                  undone = true;
                  //set state
                  setState(() {
                    //add again
                    projects.add(project);
                    filteredProjects.add(project);
                  });
                })
          ],
        )))
        .closed
        .then((value) {
      //remove project from database if not undone
      if (!undone) {
        userDoc?.collection('pro')?.doc(project.id)?.delete();
      }
    });
  }

  void tapListTile(Project pro) {
    //current time
    var time = DateTime.now().millisecondsSinceEpoch;
    //the project document
    var proDoc = userDoc.collection('pro').doc(pro.id);
    //tap list tile, write to firebase database and lists
    proDoc.update(<String, dynamic>{'lastAccessed': time});
    pro.lastAccessed = time;
    projects[projects.indexOf(pro)].lastAccessed = time;
    //update state once again
    setState(() {});
    //open a new route
    Future.microtask(() => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => TodoProjectPage(
            proDoc: proDoc,
          ),
        )));
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
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
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
    Future<void> createTabs(DocumentReference proDoc) async {
      int pos = 0;
      for (var name in ['todo', 'doing', 'done']) {
        await TodoTab.addNew(proDoc, name, (++pos) * 1000);
      }
    }

    //show the dialog
    showAnimatedDialog(context,
        title: strings.add_project,
        inputFields: 1,
        inputFieldsHints: [
          strings.project_name
        ],
        inputTypes: [
          TextInputType.text
        ],
        inputValidators: [
          (value) => (isEmpty(value) ? null : strings.project_name)
        ], onDone: (value) {
      //the time
      var time = DateTime.now().millisecondsSinceEpoch;
      //add to firestore the object
      Map<String, dynamic> projectMap = {
        'name': value[0],
        'lastAccessed': time,
        'sortingType': TodoItemSortingType.custom,
        'itemCount': 0,
      };
      //create max 100 projects
      if (projects.length < 100)
        userDoc.collection('pro').add(projectMap).then((snapshot) {
          //create project with id
          var project = Project(snapshot.id, value[0], time, 0);
          //create the tabs
          createTabs(userDoc.collection('pro').doc(project.id)).then((value) =>
              //new state
              setState(() {
                //add to the lists
                projects.add(project);
                filteredProjects.add(project);
              }));
        });
      else
        showSnackBar(strings.too_many_projects);
    });
  }
}
