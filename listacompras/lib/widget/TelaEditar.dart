import 'package:flutter/material.dart';

class TelaEditar extends StatelessWidget{
  const TelaEditar({Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edição da Lista de Compras'),
      ),
      body: const Center(
        child: Text('Aqui seria a parte de edição dos items.'),
      ),
    );
  }
}