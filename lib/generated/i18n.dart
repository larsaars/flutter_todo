// DO NOT EDIT. This is code generated via package:gen_lang/generate.dart

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'messages_all.dart';

class S {
 
  static const GeneratedLocalizationsDelegate delegate = GeneratedLocalizationsDelegate();

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }
  
  static Future<S> load(Locale locale) {
    final String name = locale.countryCode == null ? locale.languageCode : locale.toString();

    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new S();
    });
  }
  
  String get ok {
    return Intl.message("ok", name: 'ok');
  }

  String get cancel {
    return Intl.message("cancel", name: 'cancel');
  }

  String get error {
    return Intl.message("error", name: 'error');
  }

  String get loading_web {
    return Intl.message("loading...", name: 'loading_web');
  }

  String get privacy_title {
    return Intl.message("Privacy Policy", name: 'privacy_title');
  }

  String get privacy_url {
    return Intl.message("https://todo-redefined.flycricket.io/privacy.html", name: 'privacy_url');
  }

  String get terms_url {
    return Intl.message("https://todo-redefined.flycricket.io/terms.html", name: 'terms_url');
  }

  String get terms_title {
    return Intl.message("Terms & Conditions", name: 'terms_title');
  }

  String get login_sign_in_with_email {
    return Intl.message("sign in with e-mail", name: 'login_sign_in_with_email');
  }

  String get login_register {
    return Intl.message("register", name: 'login_register');
  }

  String get login_login {
    return Intl.message("sign in", name: 'login_login');
  }

  String get login_email {
    return Intl.message("e-mail", name: 'login_email');
  }

  String get login_please_enter_email {
    return Intl.message("please enter your e-mail", name: 'login_please_enter_email');
  }

  String get login_enter_password {
    return Intl.message("please enter a password", name: 'login_enter_password');
  }

  String get login_password {
    return Intl.message("password", name: 'login_password');
  }

  String login_sign_in_failed(errorMsg) {
    return Intl.message("sign in failed: ${errorMsg}", name: 'login_sign_in_failed', args: [errorMsg]);
  }

  String get login_sign_in_with_google {
    return Intl.message("sign in with google", name: 'login_sign_in_with_google');
  }


}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
			Locale("en", ""),
			Locale("de", ""),

    ];
  }

  LocaleListResolutionCallback listResolution({Locale fallback}) {
    return (List<Locale> locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return fallback ?? supported.first;
      } else {
        return _resolve(locales.first, fallback, supported);
      }
    };
  }

  LocaleResolutionCallback resolution({Locale fallback}) {
    return (Locale locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported);
    };
  }

  Locale _resolve(Locale locale, Locale fallback, Iterable<Locale> supported) {
    if (locale == null || !isSupported(locale)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  @override
  Future<S> load(Locale locale) {
    return S.load(locale);
  }

  @override
  bool isSupported(Locale locale) =>
    locale != null && supportedLocales.contains(locale);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;
}

// ignore_for_file: unnecessary_brace_in_string_interps
