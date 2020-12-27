import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as timeago;

final Random random = Random();
final uuid = Uuid();

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
    _emailRegex == null
        ? _emailRegex = RegExp(await rootBundle.loadString('res/regex/email'))
        : _emailRegex;

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

bool isEmpty(obj, [emptyObj]) {
  if (obj == null || (emptyObj != null && obj == emptyObj))
    return true;

  if (obj is Iterable)
    return obj.isEmpty;
  else if (obj is String)
    return obj.isEmpty;
  else if (obj is Map)
    return obj.isEmpty;
  else if (obj is num)
    return obj == 0;

  return false;
}

String formatTime(BuildContext context, DateTime dateTime) {
  //get localization
  var loc = MaterialLocalizations.of(context);
  //if the given time lays in the past, return via timeago
  if (dateTime.millisecondsSinceEpoch < DateTime
      .now()
      .millisecondsSinceEpoch)
    return timeago.format(dateTime);
  else
    return loc.formatCompactDate(dateTime);
}