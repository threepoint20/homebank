import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String title;
  final String subtitle;
  final String route;
  const Labels({
    super.key, // 修正: 使用 super.key 的現代寫法
    required this.title, // 修正: 使用 required 關鍵字
    required this.route, // 修正: 使用 required 關鍵字
    required this.subtitle, // 修正: 使用 required 關鍵字
  });

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
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            child: Text(
              subtitle,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, route);
            },
          ),
        ],
      ),
    );
  }
}
