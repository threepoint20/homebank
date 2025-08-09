import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String title;

  const Logo({
    super.key, // 修正: 使用 super.key 的現代寫法
    required this.title, // 修正: 使用 required 關鍵字
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 180,
            child: Image(image: AssetImage('assets/images/user_icon.png')),
          ),
        ],
      ),
    );
  }
}
