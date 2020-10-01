import 'dart:io';

import 'package:chat_app/model/mensajes_response_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_services.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _escribiendo = false;
  List<ChatMessage> _msn = [];
  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  @override
  void initState() { 
    super.initState();
    this.chatService   = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService   = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(this.chatService.userRecep.uid);

  }

  void _cargarHistorial( String usuarioID) async {

    List<Mensaje> chat = await this.chatService.getChat(usuarioID);
    final history = chat.map((e) => new ChatMessage(
      texto: e.mensaje, 
      uid: e.de, 
      animationController: new AnimationController(vsync: this, duration: Duration(milliseconds: 300))..forward()
    ));
    setState(() {
      _msn.insertAll(0, history);
    });
  }

  void _escucharMensaje(payload){
    ChatMessage message = new ChatMessage(
      texto: payload['mensaje'], 
      uid: payload['de'], 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300))
    );
    setState(() {
      _msn.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final userRecep = Provider.of<ChatService>(context).userRecep;
    return Scaffold(
        appBar: AppBar(
          elevation: 1.0,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Text(userRecep.nombre.substring(0,2)),
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                userRecep.nombre,
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
                    itemBuilder: (_, i) => _msn[i]),
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
                      texto.trim().length > 0
                          ? _escribiendo = true
                          : _escribiendo = false;
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
                                ? () =>
                                    _onSubmitted(_textController.text.trim())
                                : null)
                        : Container(
                            child: IconTheme(
                              data: IconThemeData(color: Colors.blue),
                              child: IconButton(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: Icon(Icons.send),
                                onPressed: _escribiendo
                                    ? () => _onSubmitted(
                                        _textController.text.trim())
                                    : null,
                              ),
                            ),
                          ))
              ],
            )));
  }

  _onSubmitted(String texto) {
    if (texto.length == 0) return print(texto);
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = new ChatMessage(
        texto: texto,
        uid: authService.usuario.uid,
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));
    _msn.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() { _escribiendo = false; });
    this.socketService.socket.emit('mensaje-personal', {
      'de': this.authService.usuario.uid,
      'para': this.chatService.userRecep.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _msn) {
      message.animationController.dispose();
    }
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
