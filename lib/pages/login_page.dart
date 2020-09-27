import 'package:chat_app/widgets/Label.dart';
import 'package:chat_app/widgets/boton_azul.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:flutter/material.dart';

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
            onPressed: () {
              print(emailController.text);
              print(passController.text);
            },
            text: 'ingrese',
          ),
        ],
      ),
    );
  }
}
