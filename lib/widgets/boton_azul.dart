import 'package:flutter/material.dart';

class Boton extends StatelessWidget {
  final Function onPressed;
  final String text;

  const Boton({
    Key key, 
    @required this.onPressed, 
    @required this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: StadiumBorder(),
      color: Colors.blue,
      elevation: 5.0,
      onPressed: this.onPressed,
      child: Container(
          height: 50.0,
          width: double.infinity,
          child: Center(
            child: Text(
              this.text,
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          )),
    );
  }
}
