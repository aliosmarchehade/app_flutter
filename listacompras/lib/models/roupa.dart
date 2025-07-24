class Roupa {
  int? id;
  String nomeRoupa;
  String? tamanho;
  String? marca;
  double? preco;
  bool favorito; 

  Roupa({
    this.id,
    required this.nomeRoupa,
    this.tamanho,
    this.marca,
    this.preco,
    this.favorito = false,
  });
}
