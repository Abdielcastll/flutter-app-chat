import 'package:chat_app/model/usuario_model.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsuariosPage extends StatefulWidget {

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);
 
  List<Usuario> usuarios = [
    Usuario(uid: '1', nombre: 'Abdiel', email: 'test1@test.com', online: true),
    Usuario(uid: '2', nombre: 'Jose', email: 'test2@test.com', online: false),
    Usuario(uid: '3', nombre: 'David', email: 'test3@test.com', online: true),
  ]; 
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          authService.usuario.nombre, 
          style: TextStyle(color: Colors.black45),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 15.0),
            child: Icon(
              Icons.check_circle, color: Colors.blue,
              // Icons.offline_bolt, color: Colors.red
            ),
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          color: Colors.black,
          onPressed: (){
            //TODO : Desconectar el socket service.
            AuthService.deleteToken();
            Navigator.pushReplacement( context, PageRouteBuilder(pageBuilder: ( _, __, ___) => LoginPage()));
          }
        ),
      ),

      body: SmartRefresher(
        enablePullDown: true,
        header: WaterDropHeader(
          waterDropColor: Colors.blue,
          complete: Icon(Icons.check, color: Colors.blue,)
        ),
        onRefresh: _cargarUsuarios,
        controller: _refreshController,
        child: _listViewUsuarios(),
      ),
   );
  }

  _cargarUsuarios() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: usuarios.length,
      separatorBuilder: ( _ , i) => Divider(),
      itemBuilder: ( _ , i) {
      return _usuarioListTile(usuarios[i]);
     },
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(usuario.nombre.substring(0,2)),
        ),
        title: Text(usuario.nombre),
        subtitle: Text(usuario.email),
        trailing: Container(
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: usuario.online? Colors.green : Colors.red
          ),
        ),
      );
  }
}