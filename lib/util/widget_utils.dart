import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/ui/style.dart';
import 'package:todo/ui/widget/divider.dart';
import 'package:todo/ui/widget/standard_widgets.dart';
import 'package:todo/util/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

RoundedRectangleBorder roundButtonShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(45));

RoundedRectangleBorder roundedButtonShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));

AppBar appBar(BuildContext context, String title,
        [bool withIcon = false, List<Widget> actions]) =>
    AppBar(
      actions: actions,
      leading: withIcon
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'res/drawable/ic_launcher.png',
              ),
            )
          : IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Styles.white54IconColor,
              ),
              onPressed: Navigator.of(context).pop,
            ),
      title: Text(title,
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .copyWith(color: Styles.whiteTextFieldColor)),
    );

typedef void OnDialogCancelCallback(value);
typedef void OnDialogReturnSetStateCallback(BuildContext context, setState);

bool _showing = false;

Future showAnimatedDialog(
  BuildContext context, {
  Widget dialog,
  String title,
  String text,
  String onDoneText,
  bool forceNoCancelButton = false,
      bool forceShow = false,
  bool warningOnDoneButton = false,
  String forceCancelText,
  List<Widget> children = const [],
  OnDialogCancelCallback onDone,
  OnDialogReturnSetStateCallback setStateCallback,
  IconData icon,
  var update,
  bool showAnyActionButton = true,
  int inputFields = 0,
  List<String> inputFieldsHints,
  List<TextInputType> inputTypes,
  List<FormFieldValidator> inputValidators,
}) async {
  if (_showing && !forceShow) return;

  _showing = true;

  //create lists with valid lengths
  inputFieldsHints ??= List(inputFields);
  inputTypes ??= List(inputFields);
  inputValidators ??= List(inputFields);

  //the input texts
  List<String> inputTexts = List(inputFields);

  //create input fields list
  List<Widget> inputWidgets = [];
  for (int i = 0; i < inputFields; i++) {
    var isPassword = inputTypes[i] == TextInputType.visiblePassword;
    inputWidgets.add(TextFormField(
      maxLines: 1,
      validator: inputValidators[i],
      keyboardType: isPassword
          ? TextInputType.text
          : (inputTypes[i] ?? TextInputType.text),
      obscureText: isPassword,
      onChanged: (value) => inputTexts[i] = value,
      decoration: InputDecoration(hintText: inputFieldsHints[i]),
      autofocus: true,
    ));
  }

  //show dialog
  var value = await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    pageBuilder: (context, animation1, animation2) {
      return Container();
    },
    transitionBuilder: (context, a1, a2, widget) {
      final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
      return Transform(
        transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
        child: Opacity(
          opacity: a1.value,
          child: dialog ??
              StatefulBuilder(builder: (context, setState) {
                //call the listener that returns the set state
                if (setStateCallback != null)
                  setStateCallback(context, setState);
                //create the alert dialog object
                return AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      icon == null ? Container() : Icon(icon),
                      Divider8(),
                      Text(
                        title ?? '',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      (text == null)
                          ? SizedBox()
                          : Center(
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 400),
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  text ?? "",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ),
                            ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: inputWidgets + makeNonNull<Widget>(children),
                      ),
                    ],
                  ),
                  actions: showAnyActionButton
                      ? makeNonNull<Widget>([
                          forceNoCancelButton
                              ? null
                              : DefaultFlatButton(
                                  text: (forceCancelText != null
                                      ? forceCancelText
                                      : (onDone == null
                                          ? strings.ok
                                          : strings.cancel)),
                                  onPressed: () {
                                    _showing = false;
                                    Navigator.of(context)
                                        .pop(onDone == null ? 'ok' : null);
                                  }),
                          onDone != null
                              ? DefaultFilledButton(
                                  text: onDoneText ?? strings.ok,
                                  onPressed: () {
                                    _showing = false;
                                    Navigator.of(context).pop('ok');
                                  },
                                  warningButton: warningOnDoneButton,
                                )
                              : Container()
                        ])
                      : [],
                );
              }),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 300),
  );
  //set showing dialog false
  _showing = false;
  //execute the on done
  if (onDone != null && value != null) {
    if (isEmpty(inputFields)) {
      onDone(value);
      return value;
    } else {
      onDone(inputTexts);
      return inputTexts;
    }
  }

  return value;
}

Future<String> showInputFieldDialog(
  BuildContext context, {
  String hint,
  String title,
}) async {
  var values = await showAnimatedDialog(context,
      title: title,
      inputFields: 1,
      inputFieldsHints: [hint],
      inputTypes: [TextInputType.text],
      inputValidators: [(value) => (isEmpty(value) ? null : '')],
      onDone: (value) {});
  return values[0];
}

void showAbout(BuildContext context) async {
  //show the about dialog
  showAboutDialog(
    context: context,
    applicationVersion: version,
    applicationIcon: Image.asset(
      'res/drawable/ic_launcher.png',
      width: 50,
      height: 50,
    ),
    applicationLegalese: await rootBundle.loadString('res/licenses/this'),
    children: [
      DefaultFlatButton(
        onPressed: () => launch(strings.privacy_url),
        text: strings.privacy_title,
      ),
      DefaultFlatButton(
        onPressed: () => launch(strings.terms_url),
        text: strings.terms_title,
      ),
    ],
  );
}
