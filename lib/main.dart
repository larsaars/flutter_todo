import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/ui/login/log_in_page.dart';
import 'package:todo/ui/style.dart';
import 'package:todo/ui/widget/modal_progress_hud.dart';
import 'package:todo/util/utils.dart';
import 'package:todo/util/widget_utils.dart';

import 'generated/i18n.dart';

part 'app_controller.dart';

void main() async {
  //run the app
  runApp(MyApp());
  //init firebase app
  Firebase.initializeApp();
  //add all licenses
  addLicenses();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*//set fullscreen
    SystemChrome.setEnabledSystemUIOverlays([]);*/
    //and portrait only
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    //create the material app
    return ChangeNotifierProvider(
      create: (_) => themeChangeProvider,
      child: Consumer<DarkThemeProvider> (
        builder: (context, value, child) {
          return MaterialApp(
            //no debug flag
            debugShowCheckedModeBanner: false,
            //manage resources first
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            //define title etc.
            title: app_name,
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            darkTheme: Styles.themeData(true, context),
            home: MyHomePage(),
          );
        }
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomePage> {
  Future<void> _loadEverythingUp() async {
    //await prefs
    prefs = await SharedPreferences.getInstance();
    //has to load is now false
    _controller.hasToLoad = false;
  }

  @override
  Widget build(BuildContext context) {
    //set strings object
    strings ??= S.of(context);
    //build the chess controller,
    //if needed set context newly
    if (_controller == null)
      _controller = AppRootController(context);
    else
      _controller.context = context;
    //future builder: load old screen and show here on start the loading screen,
    //when the future is finished,
    //with setState show the real scaffold
    //return the view
    return (_controller.hasToLoad)
        ? FutureBuilder(
            future: _loadEverythingUp(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  var error = snapshot.error;
                  print('$error');
                  return Center(child: Text(strings.error));
                }

                return MyHomePageAfterLoading();
              } else {
                return Center(
                    child: ModalProgressHUD(
                  child: Container(),
                  inAsyncCall: true,
                ));
              }
            },
          )
        : MyHomePageAfterLoading();
  }
}

class MyHomePageAfterLoading extends StatefulWidget {
  MyHomePageAfterLoading({Key key}) : super(key: key);

  @override
  _MyHomePageAfterLoadingState createState() => _MyHomePageAfterLoadingState();
}

class _MyHomePageAfterLoadingState extends State<MyHomePageAfterLoading>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _onWillPop();
        break;
      default:
        break;
    }
  }

  void update() {
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    //set the update method
    _controller.update = update;
    //the default scaffold
    return WillPopScope(
      onWillPop: _onWillPop,
      child: ModalProgressHUD(
        inAsyncCall: _controller.loading,
        progressIndicator: kIsWeb
            ? Text(
                strings.loading_web,
                style: Theme.of(context).textTheme.subtitle2,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
        child: SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                LogInPage(
                  title: app_name,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.info,
                      color: Styles.greyIconColor,
                    ),
                    onPressed: () => showAbout(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
