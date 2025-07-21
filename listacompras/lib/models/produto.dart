class Produto {
  int? id;
  String nome;
  double preco;
  int categoriaId; // <- nova associação

  Produto({
    this.id,
    required this.nome,
    required this.preco,
    required this.categoriaId,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'nome': nome,
    'preco': preco,
    'categoriaId': categoriaId, // <- salva a relação
  };

  static Produto fromMap(Map<String, dynamic> map) => Produto(
    id: map['id'],
    nome: map['nome'],
    preco: map['preco'],
    categoriaId: map['categoriaId'], // <- recupera a relação
  );
}
