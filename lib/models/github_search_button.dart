import 'package:flutter/material.dart';

class GithubSearchButton extends StatelessWidget {
  String myText;
  Color myColor;
  Function myFunction;

  GithubSearchButton(
      {@required String text,
      @required Color color,
      @required Function onTap}) {
    myText = text;
    myColor = color;
    myFunction = onTap;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: myFunction,
      child: Container(
        width: double.infinity,
        height: 200,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              myColor.withOpacity(0.2),
              myColor.withOpacity(0.6),
              myColor.withOpacity(0.8),
              myColor,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black38,
              offset: Offset(0, 2),
              spreadRadius: 1,
            ),
            BoxShadow(
              blurRadius: 5,
              color: myColor.withOpacity(0.5),
              offset: Offset(2, 5),
              spreadRadius: 1,
            ),
          ],
        ),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomRight,
        child: Text(
          myText,
          style: TextStyle(fontSize: 22, color: Colors.white, shadows: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black, //myColor.withOpacity(0.1),
              offset: Offset(0, 1),
              spreadRadius: 1,
            ),
          ]),
        ),
      ),
    );
  }
}
