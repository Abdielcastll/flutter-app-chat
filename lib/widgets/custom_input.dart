import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextInputType type;
  final TextEditingController textcontroller;
  final bool obscureText;

  const CustomInput({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.textcontroller,
    this.type = TextInputType.text,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, offset: Offset(0, 3), blurRadius: 2)
            ]),
        child: TextField(
          obscureText: this.obscureText,
          controller: this.textcontroller,
          autocorrect: false,
          keyboardType: this.type,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: this.text,
            icon: Icon(this.icon),
          ),
        ));
  }
}
