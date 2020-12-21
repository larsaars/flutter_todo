import 'package:flutter/material.dart';
import 'package:todo/util/widget_utils.dart';

class DefaultFilledButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool warningButton;

  DefaultFilledButton({
    @required this.text,
    @required this.onPressed,
    this.warningButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      shape: roundedButtonShape,
      fillColor: warningButton ? Colors.red[800] : Colors.indigo,
      splashColor: warningButton ? Colors.red[600] : Colors.indigo[400],
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.white)),
      onPressed: onPressed,
    );
  }
}

class DefaultFlatButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  DefaultFlatButton({
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

class DefaultIcon extends StatelessWidget {
  final IconData icon;

  DefaultIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(45),
      child: Container(
        color: Colors.white54,
        child: Icon(
          icon,
          color: Colors.black54,
        ),
      ),
    );
  }
}
