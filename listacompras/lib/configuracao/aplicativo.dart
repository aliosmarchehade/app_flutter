import 'package:flutter/material.dart';
import 'package:listacompras/configuracao/rotas.dart';
import 'package:listacompras/widget/TelaEletronicos.dart';
import 'package:listacompras/widget/TelaFarmacia.dart';
import 'package:listacompras/widget/TelaMecanica.dart';
import 'package:listacompras/widget/TelaOutros.dart';
import 'package:listacompras/widget/TelaPetshop.dart';
import 'package:listacompras/widget/TelaRoupas.dart';
import 'package:listacompras/widget/TelaInicial.dart';
import 'package:listacompras/widget/TelaMercado.dart';

class Aplicativo extends StatelessWidget{
  const Aplicativo({key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Aula Widget',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Rotas.home,
      routes: {
        Rotas.home:(context) =>  TelaInicial(),
        Rotas.supermercado:(context) => const TelaMercado(),
        Rotas.roupas:(context) => const TelaRoupas(),
        Rotas.farmacia:(context) => const TelaFarmacia(),
        Rotas.eletronicos:(context) => const TelaEletronicos(),
        Rotas.petshop:(context) => const TelaPetshop(),
        Rotas.mecanica:(context) => const TelaMecanica(),
        Rotas.outros:(context) => const TelaOutros(),


      },
    );
  }
}