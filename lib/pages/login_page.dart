import 'package:chat_app/helpers/mostrar_alerta.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/Label.dart';
import 'package:chat_app/widgets/boton_azul.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(title: 'Messenger',),
                  _Form(),
                  Label(
                    titulo: '¿No tienes cuenta?', 
                    subtitulo: 'Registrate', 
                    ruta: 'register'
                  ),
                  Text('Terminos y condiciones', style: TextStyle()),
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = new TextEditingController();
  final passController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
   
    final authService = Provider.of<AuthService>(context);
   
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            text: 'Correo',
            type: TextInputType.emailAddress,
            textcontroller: emailController,
          ),
          CustomInput(
            icon: Icons.security,
            text: 'Contraseña',
            obscureText: true,
            textcontroller: passController,
          ),
          SizedBox(
            height: 15.0,
          ),
          Boton(
            onPressed: authService.autenticando ? null : () async {
              final loginOK = await authService.login(emailController.text.trim(), passController.text.trim());
              if (loginOK) {
                
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                mostrarAlerta(context, 'Error', 'Email o contraseña incorrecta');
              }
            },
            text: 'Ingresar',
          ),
        ],
      ),
    );
  }
}
