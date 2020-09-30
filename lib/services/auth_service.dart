import 'package:chat_app/model/usuario_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/model/login_response_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {

  Usuario usuario;
  bool _autendticando = false;

  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autendticando;
  set autenticando(bool valor){
    this._autendticando = valor;
    notifyListeners();
  }

  //Getters del token de forma estatica
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }
  
  Future<bool> login(String email, String password) async {
    this.autenticando = true;

    final data = {'password': password, 'email': email};

    final resp = await http.post('${Environment.apiURL}/login',
        body: jsonEncode(data), headers: {'Content-Type':'application/json'});

    this.autenticando = false;
    if(resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future register(String nombre, String password, String email) async {
    
    this.autenticando = true;

    final data = {'nombre': nombre, 'password': password, 'email': email};

    final resp = await http.post('${Environment.apiURL}/login/new',
        body: jsonEncode(data), headers: {'Content-Type':'application/json'});

    this.autenticando = false;
    if(resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      final respbody = jsonDecode(resp.body);
      return respbody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    
    final token = await this._storage.read(key: 'token');

    final resp = await http.get('${Environment.apiURL}/login/renew',
        headers: {
          'x-token': token,
          'Content-Type':'application/json'  
        });


    if(resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      this.logout();
      return false;
    }

  }

  Future _guardarToken(String token) async {
      return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
