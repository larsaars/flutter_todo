import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

final Random random = Random();

Future<String> get rootDir async {
  final directory = await getApplicationDocumentsDirectory();
  // For your reference print the AppDoc directory
  return directory.path;
}

class ContextSingleton {
  static ContextSingleton _instance;
  final BuildContext _context;

  ContextSingleton(this._context) {
    _instance = this;
  }

  static get context {
    return _instance._context;
  }
}

void addLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(['modal_progress_hud'],
        await rootBundle.loadString('res/licenses/modal_progress_hud'));
  });
}

// ignore: non_constant_identifier_names
Future<String> get EMAIL_REGEX async => await rootBundle.loadString('res/regex/email');

bool passwordValidates(String pass) {
  int count = 0;

  if (8 <= pass.length && pass.length <= 32) {
    if (RegExp(".*\\d.*").hasMatch(pass)) count++;
    if (RegExp(".*[a-z].*").hasMatch(pass)) count++;
    if (RegExp(".*[A-Z].*").hasMatch(pass)) count++;
    if (RegExp('^.*[*.!@#\$%^&(){}[]:\";\'<>,.?/~`_+-=|\\].*\$')
        .hasMatch(pass)) count++;
  }

  return count >= 3;
}