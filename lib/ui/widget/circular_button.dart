import 'package:flutter/material.dart';

import '../style.dart';

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final IconData icon;
  final Function onPressed;

  CircularButton({
    this.color = Colors.indigo,
    this.width,
    this.height,
    @required this.icon,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: width,
      height: height,
      child: IconButton(
          icon: Icon(
            icon,
            color: Styles.white54IconColor,
          ),
          enableFeedback: true,
          onPressed: onPressed),
    );
  }
}
