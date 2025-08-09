import 'dart:io';

import 'package:flutter/material.dart';
class TitleAppbar extends StatelessWidget {

  final String title;
  final IconData icon;
  
  const TitleAppbar({
    Key key, 
    @required this.title, 
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Platform.isIOS ? SizedBox(height: 10,)
        : Container(),
        Row(
          children: <Widget>[
            Platform.isIOS 
            ? Container()
            : Icon(
              icon,
              color: Colors.blue[700],
              size: 20,
            ),
            Platform.isIOS 
            ? Container(): SizedBox(width: 10,),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: Platform.isIOS ? TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black

                    
              ): TextStyle(
                fontSize: 18,
              
                fontWeight: FontWeight.bold,
                color: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .color
                    .withOpacity(.7),

              ),
            )
          ],
        ),
      ],
    );
  }
}