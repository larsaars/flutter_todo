part of 'main.dart';

const version = '1.0';
const app_name = 'todo redefined';

S strings;
SharedPreferences prefs;
AppRootController _controller;

FirebaseFirestore firestore = FirebaseFirestore.instance;

class AppRootController {
  BuildContext context;
  Function update;

  bool loading = false, hasToLoad = true;

  AppRootController(this.context);
}