import 'package:flutter/material.dart';

class TelaLista extends StatelessWidget{
  const TelaLista({Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Lista'),
      ),
      body: const Center(
        child: Text('Aqui vai a minha lista de compras.'),
      ),
    );
  }
}