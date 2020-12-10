// DO NOT EDIT. This is code generated via package:gen_lang/generate.dart

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
// ignore: implementation_imports
import 'package:intl/src/intl_helpers.dart';

final _$de = $de();

class $de extends MessageLookupByLibrary {
  get localeName => 'de';
  
  final messages = {
		"ok" : MessageLookupByLibrary.simpleMessage("ok"),
		"cancel" : MessageLookupByLibrary.simpleMessage("schließen"),
		"error" : MessageLookupByLibrary.simpleMessage("Fehler"),
		"loading_web" : MessageLookupByLibrary.simpleMessage("lädt..."),

  };
}

final _$en = $en();

class $en extends MessageLookupByLibrary {
  get localeName => 'en';
  
  final messages = {
		"ok" : MessageLookupByLibrary.simpleMessage("ok"),
		"cancel" : MessageLookupByLibrary.simpleMessage("cancel"),
		"error" : MessageLookupByLibrary.simpleMessage("error"),
		"loading_web" : MessageLookupByLibrary.simpleMessage("loading..."),
		"privacy_title" : MessageLookupByLibrary.simpleMessage("Privacy Policy"),
		"privacy_url" : MessageLookupByLibrary.simpleMessage("https://todo-redefined.flycricket.io/privacy.html"),
		"terms_url" : MessageLookupByLibrary.simpleMessage("https://todo-redefined.flycricket.io/terms.html"),
		"terms_title" : MessageLookupByLibrary.simpleMessage("Terms & Conditions"),

  };
}



typedef Future<dynamic> LibraryLoader();
Map<String, LibraryLoader> _deferredLibraries = {
	"de": () => Future.value(null),
	"en": () => Future.value(null),

};

MessageLookupByLibrary _findExact(localeName) {
  switch (localeName) {
    case "de":
        return _$de;
    case "en":
        return _$en;

    default:
      return null;
  }
}

/// User programs should call this before using [localeName] for messages.
Future<bool> initializeMessages(String localeName) async {
  var availableLocale = Intl.verifiedLocale(
      localeName,
          (locale) => _deferredLibraries[locale] != null,
      onFailure: (_) => null);
  if (availableLocale == null) {
    return Future.value(false);
  }
  var lib = _deferredLibraries[availableLocale];
  await (lib == null ? Future.value(false) : lib());

  initializeInternalMessageLookup(() => CompositeMessageLookup());
  messageLookup.addLocale(availableLocale, _findGeneratedMessagesFor);

  return Future.value(true);
}

bool _messagesExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    return false;
  }
}

MessageLookupByLibrary _findGeneratedMessagesFor(locale) {
  var actualLocale = Intl.verifiedLocale(locale, _messagesExistFor,
      onFailure: (_) => null);
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}

// ignore_for_file: unnecessary_brace_in_string_interps