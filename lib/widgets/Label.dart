import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final String ruta;

  const Label({
    Key key, 
    @required this.titulo,
    @required this.subtitulo,
    @required this.ruta
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(this.titulo, style: TextStyle(color: Colors.black45,),),
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, this.ruta),
            child: Text(this.subtitulo, style: TextStyle(color: Colors.blue[600], fontSize: 18.0, fontWeight: FontWeight.bold),)
          ),
        ],
      ),
    );
  }
}