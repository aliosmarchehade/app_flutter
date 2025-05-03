import 'package:flutter/material.dart';
import 'package:listacompras/configuracao/rotas.dart';
import 'package:listacompras/widget/TelaEditar.dart';
import 'package:listacompras/widget/TelaInicial.dart';
import 'package:listacompras/widget/TelaLista.dart';

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
        Rotas.lista_nomes:(context) => const TelaLista(),
        Rotas.llista_editar:(context) => const TelaEditar(),
        // Rotas.pessoa:(context) => const WidgetPessoa(),
        // Rotas.categoria:(context) => const WidgetCategoria(),
        // Rotas.produto:(context) => const WidgetProduto(),
        // Rotas.lista_pessoa:(context) => WidgetPessoaLista(),

      },
    );
  }
}