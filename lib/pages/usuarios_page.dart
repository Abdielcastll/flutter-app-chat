import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/model/usuario_model.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_services.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsuariosPage extends StatefulWidget {

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuarioService = new UsuarioService();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
 
  List<Usuario> usuarios = []; 
  
  @override
  void initState() { 
    super.initState();
    this._cargarUsuarios();  
  }
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

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
            child: socketService.serverStatus == ServerStatus.Online
                    ? Icon(Icons.check_circle, color: Colors.blue) 
                    : Icon(Icons.offline_bolt, color: Colors.red)
            ),
        ],
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          color: Colors.black,
          onPressed: (){
            socketService.disconnect();
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
    //await Future.delayed(Duration(milliseconds: 1000));
    this.usuarios = await usuarioService.getUsuarios();
    setState((){});
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
        onTap: (){
          final chatService = Provider.of<ChatService>(context,listen: false);
          chatService.userRecep = usuario;
          Navigator.pushNamed(context, 'chat');
        },
      );
  }
}