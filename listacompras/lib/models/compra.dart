class Compra {
  int? id;
  String nomeProduto;
  DateTime dataCompra;
  int quantidade;
  double precoTotal;
  String categoria;
  bool favorito;
  String? tipoVeiculo;  // NOVO CAMPO OPCIONAL

  Compra({
    this.id,
    required this.nomeProduto,
    required this.dataCompra,
    required this.quantidade,
    required this.precoTotal,
    required this.categoria,
    this.favorito = false,
    this.tipoVeiculo,
  });
}
