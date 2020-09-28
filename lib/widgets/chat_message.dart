import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String texto;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    Key key, 
    @required this.texto, 
    @required this.uid, 
    @required this.animationController
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeInQuart),
        child: Container(
          child: this.uid == '12' ? _myMsg() : _noMyMsg(),
        ),
      ),
    ); 
  }

  Widget _myMsg(){
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(left: 60.0, bottom: 10.0, right: 10.0 ),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(50.0)
        ),
        child: Text(this.texto, style: TextStyle(color: Colors.white),),
      ),
    );
  }
  
  Widget _noMyMsg(){
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(left: 10.0, bottom: 10.0, right: 60.0 ),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(50.0)
        ),
        child: Text(this.texto, style: TextStyle(color: Colors.white),),
      ),
    );
  }
}