class Compra {
  int? id;
  String nomeProduto;
  DateTime dataCompra;
  int quantidade;
  double precoTotal;

  Compra({
    this.id,
    required this.nomeProduto,
    required this.dataCompra,
    required this.quantidade,
    required this.precoTotal,
  });
}