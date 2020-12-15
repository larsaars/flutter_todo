part of 'main.dart';

S strings;
SharedPreferences prefs;
AppRootController _controller;

class AppRootController {
  BuildContext context;
  Function update;

  bool loading = false, hasToLoad = true;

  AppRootController(this.context);
}