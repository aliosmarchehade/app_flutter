class ProdutoFavorito {
  int produtoId;
  int favoritoId;

  ProdutoFavorito({required this.produtoId, required this.favoritoId});

  Map<String, dynamic> toMap() {
    return {
      'produtoId': produtoId,
      'favoritoId': favoritoId,
    };
  }

  static ProdutoFavorito fromMap(Map<String, dynamic> map) {
    return ProdutoFavorito(
      produtoId: map['produtoId'],
      favoritoId: map['favoritoId'],
    );
  }
}
