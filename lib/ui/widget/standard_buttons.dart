import 'package:flutter/material.dart';
import 'package:todo/util/widget_utils.dart';

class StandardFilledButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  StandardFilledButton({
    @required this.text,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      shape: roundedButtonShape,
      fillColor: Colors.indigo,
      splashColor: Colors.indigo[400],
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.white)),
      onPressed: onPressed,
    );
  }
}

class StandardFlatButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  StandardFlatButton({
    @required this.text,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.indigo)),
      shape: roundedButtonShape,
      onPressed: onPressed,
    );
  }
}
