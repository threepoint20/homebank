import 'package:flutter/material.dart';

class IconButtonCustom extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const IconButtonCustom({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
        padding: EdgeInsets.zero, // 移除內邊距
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 0, // 移除陰影
      ),
      onPressed: onTap,
      child: Container(
        height: 55,
        alignment: Alignment.center, // 確保內容置中
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email, color: Theme.of(context).primaryColor),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
