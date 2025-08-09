import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String title;
  final String subtitle;
  final String route;
  const Labels(
      {Key key,
      @required this.title,
      @required this.route,
      @required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            child: Text(
              subtitle,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, route);
            },
          )
        ],
      ),
    );
  }
}
