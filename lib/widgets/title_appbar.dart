import 'dart:io';
import 'package:flutter/material.dart';

class TitleAppbar extends StatelessWidget {
  final String title;
  final IconData icon;

  const TitleAppbar({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: isIOS ? 10.0 : 0.0),
          Row(
            children: <Widget>[
              if (!isIOS)
                Icon(
                  icon,
                  color: Colors.blue[700],
                  size: 20,
                ),
              SizedBox(width: isIOS ? 0 : 10),
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isIOS ? Colors.black : Theme.of(context).textTheme.titleLarge!.color?.withOpacity(0.7),
                      fontSize: isIOS ? 25 : 18,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}