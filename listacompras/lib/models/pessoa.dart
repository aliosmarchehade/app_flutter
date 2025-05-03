import 'endereco.dart';
import 'lista_compra.dart';

class Pessoa {
  String nome;
  String email;
  Endereco endereco;
  List<ListaCompra> listas;

  Pessoa({
    required this.nome,
    required this.email,
    required this.endereco,
  }) : listas = [];

  void adicionarLista(ListaCompra lista) {
    listas.add(lista);
  }
}
