import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap; // 修正: 使用更精確的類型 VoidCallback
  final double fontSize;
  final bool light;

  const LargeButton({
    super.key, // 修正: 使用 super.key 的現代寫法
    required this.title, // 修正: 使用 required 關鍵字
    required this.onTap, // 修正: 使用 required 關鍵字
    this.light = false,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: light ? Colors.white : Theme.of(context).primaryColor,
          border: Border.all(color: Theme.of(context).primaryColor, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Center(
          child: Text(
            this.title,
            style: TextStyle(
              color: light ? Theme.of(context).primaryColor : Colors.white,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
