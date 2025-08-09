import 'package:flutter/material.dart';

class IconButtonCustom extends StatelessWidget {
  final String title;
  final Function onTap;
  IconButtonCustom({
    @required this.title,
    @required this.onTap,
 
  });
  @override
  Widget build(BuildContext context) {
    return 
    ElevatedButton(
      style:  ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
         backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            
          )
        )
      ),
      onPressed: onTap,
      

      child: Container(
        height: 55,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
              Icon(Icons.email, color: Theme.of(context).primaryColor,),
              SizedBox(
                width: 10,
              ),
              Text(
                this.title,
                style: TextStyle(
                  color:Theme.of(context).primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              )

          ],
        ),
      ),
    );
    
  }
}
