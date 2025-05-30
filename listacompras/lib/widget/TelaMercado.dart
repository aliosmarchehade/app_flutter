import 'package:flutter/material.dart';
import 'package:listacompras/widget/ListaGenerica.dart'; // Importe o novo widget

class TelaMercado extends StatelessWidget { // Pode ser StatelessWidget agora, pois a lógica está no genérico
  const TelaMercado({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListaGenerica(
      titulo: 'Lista de compras Supermercado',
      appBarColor: Color.fromARGB(255, 255, 255, 255), // Exemplo de cor específica para Farmácia
      //listTileSelectedColor: Color.fromARGB(255, 139, 7, 80), // Exemplo de cor para seleção
      listTileHoverColor: Colors.black, // Exemplo de cor para hover
    );
  }
}