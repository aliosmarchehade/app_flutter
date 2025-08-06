import 'package:flutter/material.dart';
import 'package:listacompras/configuracao/rotas.dart';
import 'package:listacompras/widget/FormCategoria.dart';
import 'package:listacompras/widget/FormFarm%C3%A1cia.dart';
import 'package:listacompras/widget/FormRoupas.dart';
import 'package:listacompras/widget/TelaEletronicos.dart';
import 'package:listacompras/widget/FormMecanica.dart';
import 'package:listacompras/widget/TelaOutros.dart';
import 'package:listacompras/widget/FormPetshop.dart';
import 'package:listacompras/widget/TelaInicial.dart';
import 'package:listacompras/widget/FormSupermercado.dart';
import 'package:listacompras/models/produtoScreen.dart';
import 'package:listacompras/widget/listas/lista_compras_mercado.dart';
import 'package:listacompras/widget/listas/lista_farmacia.dart';
import 'package:listacompras/widget/listas/lista_favoritos.dart';
import 'package:listacompras/widget/listas/lista_mecanica.dart';
import 'package:listacompras/widget/listas/lista_petshop.dart';
import 'package:listacompras/widget/listas/lista_produtos.dart';
import 'package:listacompras/widget/listas/lista_roupas.dart';


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
        Rotas.supermercado:(context) => const FormCompraSupermercado(),
        Rotas.roupas:(context) => const FormRoupas(),
        Rotas.farmacia:(context) => const FormFarmacia(),
        Rotas.eletronicos:(context) => const TelaEletronicos(),
        Rotas.petshop:(context) => const FormPetshop(),
        Rotas.mecanica:(context) => const FormMecanica(),
        Rotas.outros:(context) => const TelaOutros(),
        Rotas.produtos: (context) => const FormProduto(),
        Rotas.categoria: (context) => const FormCategoria(),
    
       

      //rotas de listas

      Rotas.listaprodutos:(context) => const ListaProdutosScreen(),
      Rotas.listamercado: (context) => const ListaComprasScreen(),
      Rotas.listaroupas: (context) => const ListaRoupasScreen(),
      Rotas.listafarmacia: (context) => const LisaFarmaciaScreen(),
      Rotas.listafavoritos: (context) => const ListaFavoritosScreen(),
      Rotas.listapetshop: (context) => const ListaPetshopScreen(),
      Rotas.listamecanica: (context) => const ListaMecanicaScreen()

      },
    );
  }
}