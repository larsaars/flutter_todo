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

  String get login_bad_password {
    return Intl.message("bad password", name: 'login_bad_password');
  }

  String get account {
    return Intl.message("account", name: 'account');
  }

  String get log_off {
    return Intl.message("sign out", name: 'log_off');
  }

  String get delete_account {
    return Intl.message("delete account", name: 'delete_account');
  }

  String get change_email {
    return Intl.message("change e-mail", name: 'change_email');
  }

  String get reset_password {
    return Intl.message("change password", name: 'reset_password');
  }

  String get bad_email {
    return Intl.message("bad e-mail", name: 'bad_email');
  }

  String get new_email {
    return Intl.message("new e-mail", name: 'new_email');
  }

  String get confirm_password {
    return Intl.message("confirm password", name: 'confirm_password');
  }

  String get email_changed {
    return Intl.message("e-mail updated.", name: 'email_changed');
  }

  String get password_changed {
    return Intl.message("password updated", name: 'password_changed');
  }

  String get new_password {
    return Intl.message("new password", name: 'new_password');
  }

  String get wrong_password {
    return Intl.message("wrong password", name: 'wrong_password');
  }

  String get delete_account_title {
    return Intl.message("Delete account?", name: 'delete_account_title');
  }

  String get delete_account_text {
    return Intl.message("Are you sure that you want to delete your account and with it all todo lists?", name: 'delete_account_text');
  }

  String get search {
    return Intl.message("search", name: 'search');
  }

  String get add_project {
    return Intl.message("add project", name: 'add_project');
  }

  String get clear {
    return Intl.message("clear", name: 'clear');
  }

  String deleted_project(projectName) {
    return Intl.message("${projectName} deleted", name: 'deleted_project', args: [projectName]);
  }

  String get undo {
    return Intl.message("undo", name: 'undo');
  }

  String get project_name {
    return Intl.message("project name", name: 'project_name');
  }

  String get projects {
    return Intl.message("projects", name: 'projects');
  }

  String get rename {
    return Intl.message("rename", name: 'rename');
  }

  String get delete {
    return Intl.message("delete", name: 'delete');
  }

  String get rename_project {
    return Intl.message("rename project", name: 'rename_project');
  }

  String get about {
    return Intl.message("about", name: 'about');
  }

  String get too_many_projects {
    return Intl.message("too many projects", name: 'too_many_projects');
  }

  String get add_item {
    return Intl.message("add item", name: 'add_item');
  }

  String get sorting {
    return Intl.message("sorting", name: 'sorting');
  }

  String get sort_by {
    return Intl.message("sort by", name: 'sort_by');
  }

  String get sort_options {
    return Intl.message("custom,name,deadline", name: 'sort_options');
  }

  String get add_item_or_tab {
    return Intl.message("add item or tab", name: 'add_item_or_tab');
  }

  String get add_tab {
    return Intl.message("add tab", name: 'add_tab');
  }

  String get deadline {
    return Intl.message("deadline", name: 'deadline');
  }

  String get date {
    return Intl.message("date", name: 'date');
  }

  String get time {
    return Intl.message("time", name: 'time');
  }

  String get no_deadline {
    return Intl.message("no deadline", name: 'no_deadline');
  }

  String get change_tab_positions {
    return Intl.message("rearrange tabs", name: 'change_tab_positions');
  }

  String get delete_tab {
    return Intl.message("Are you sure that you want to delete this tab?", name: 'delete_tab');
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
