import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final Random random = Random();
final uuid = Uuid();

int get timeNow =>  DateTime.now().millisecondsSinceEpoch;

Future<String> get rootDir async {
  final directory = await getApplicationDocumentsDirectory();
  // For your reference print the AppDoc directory
  return directory.path;
}

void addLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(['modal_progress_hud'],
        await rootBundle.loadString('res/licenses/modal_progress_hud'));
  });
}

RegExp _emailRegex;
// ignore: non_constant_identifier_names
Future<RegExp> get EMAIL_REGEX async =>
    _emailRegex == null ? _emailRegex = RegExp(await rootBundle.loadString('res/regex/email')) : _emailRegex;

bool passwordValidates(String pass) {
  int count = 0;

  if (8 <= pass.length && pass.length <= 32) {
    if (RegExp(".*\\d.*").hasMatch(pass)) count++;
    if (RegExp(".*[a-z].*").hasMatch(pass)) count++;
    if (RegExp(".*[A-Z].*").hasMatch(pass)) count++;
    if (RegExp('^.*[*.!@#\$%^&(){}[]:\";\'<>,.?/~`_+-=|\\].*\$').hasMatch(pass))
      count++;
  }

  return count >= 2;
}

List makeNonNull(List list) =>
    list.where((element) => (element != null)).toList();

bool isEmpty(obj) {
  if(obj == null)
    return true;

  if(obj is Iterable)
    return obj.isEmpty;
  else if(obj is String)
    return obj.length == 0;
  else if(obj is Map)
    return obj.isEmpty;

  return false;
}