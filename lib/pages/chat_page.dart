import 'dart:io';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _escribiendo = false;
  List<ChatMessage> _msn = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Text('AR'),
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                'Abdiel Reyes',
                style: TextStyle(color: Colors.black38),
              )
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: _msn.length,
                    itemBuilder: (_, i) => _msn[i]
                ),
              ),
              Divider(
                height: 1,
              ),
              Container(
                color: Colors.white,
                child: _textField(),
              )
            ],
          ),
        ));
  }

  Widget _textField() {
    return SafeArea(
        child: Container(
            height: 50.0,
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Flexible(
                    child: TextField(
                  controller: _textController,
                  onSubmitted: _onSubmitted,
                  onChanged: (String texto) {
                    setState(() {
                      texto.trim().length > 0 ? _escribiendo = true : _escribiendo = false;
                    });
                  },
                  decoration:
                      InputDecoration.collapsed(hintText: 'Enviar mensaje'),
                  focusNode: _focusNode,
                )),
                Container(
                    child: Platform.isIOS
                        ? CupertinoButton(
                            child: Text(
                              'Enviar',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: _escribiendo
                                        ? () => _onSubmitted(_textController.text.trim()) 
                                        : null
                        )
                        : Container(
                            child: IconTheme(
                              data: IconThemeData(color: Colors.blue ),
                              child: IconButton(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: Icon(Icons.send),
                                onPressed: _escribiendo
                                        ? () => _onSubmitted(_textController.text.trim()) 
                                        : null,
                              ),
                            ),
                        ))
              ],
            )));
  }

  _onSubmitted(String texto){
    if (texto.length == 0) return
    print(texto);
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = new ChatMessage(
      texto: texto, 
      uid: '12', 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300))
    );
    _msn.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _escribiendo = false;
    });
  }

  @override
  void dispose() {
    for( ChatMessage message in _msn){
      message.animationController.dispose();
    }
    super.dispose();
  }
}
