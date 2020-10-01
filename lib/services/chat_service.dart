import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/model/mensajes_response_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/model/usuario_model.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  
  Usuario userRecep;

  Future<List<Mensaje>> getChat( String usuarioID) async {

    final resp = await http.get('${Environment.apiURL}/mensajes/$usuarioID',
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      }
    );
    final mensajesResp = mensajesResponseFromJson(resp.body);
    return mensajesResp.mensajes;
  }
}