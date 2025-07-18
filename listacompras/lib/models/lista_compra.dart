import 'produto.dart';

class ListaCompra {
  String nome;
  DateTime data;
  List<Produto> itens;

  ListaCompra({
    required this.nome,
    required this.data,
    List<Produto>? itens,
  }) : itens = itens ?? [];

  void adicionarProduto(Produto produto) {
    itens.add(produto);
  }

  void removerProduto(Produto produto) {
    itens.remove(produto);
  }


}

//essa seria uma entidade associativa (Produto e Lista).