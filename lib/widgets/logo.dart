import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String title;

  const Logo({
    Key key, 
    @required this.title}
    ) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 15,),
          Text(title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white ),),
          SizedBox(height: 20,),
          Container(
            width: 180,
            child: 
              Image(image: AssetImage('assets/images/user_icon.png')),
          ),
        ],
      ),
    );
  }
}