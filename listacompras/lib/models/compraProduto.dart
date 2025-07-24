class CompraProduto {
  int? id;
  int compraId;
  int produtoId;
  int quantidade;
  double precoUnitario;

  CompraProduto({
    this.id,
    required this.compraId,
    required this.produtoId,
    required this.quantidade,
    required this.precoUnitario,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'compraId': compraId,
    'produtoId': produtoId,
    'quantidade': quantidade,
    'precoUnitario': precoUnitario,
  };

  static CompraProduto fromMap(Map<String, dynamic> map) => CompraProduto(
    id: map['id'],
    compraId: map['compraId'],
    produtoId: map['produtoId'],
    quantidade: map['quantidade'],
    precoUnitario: map['precoUnitario'],
  );
}
