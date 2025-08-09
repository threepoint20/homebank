import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final double fontSize;
  final bool light;

  const LargeButton(
      {Key key,
      @required this.title,
      @required this.onTap,
      this.light = false,
      this.fontSize = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: light ? Colors.white : Theme.of(context).primaryColor,
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Center(
          child: Text(
            this.title,
            style: TextStyle(
                color: light ? Theme.of(context).primaryColor : Colors.white,
                fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}
