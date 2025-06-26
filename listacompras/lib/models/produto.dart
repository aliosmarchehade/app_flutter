class Produto {
  String nome;
  int quantidade;
  double preco;
  bool comprado;

  Produto({
    required this.nome,
    required this.quantidade,
    required this.preco,
    this.comprado = false,
  }) {
    if (quantidade <= 0) throw Exception("Quantidade deve ser maior que 0"); //1ª validação
    if (nome.isEmpty) throw Exception("Nome do produto não pode estar vazio"); //2ª validação
  }

  void marcarComoComprado() {
    comprado = true;
  }
}
