class Produto {
  int? id;
  String nome;
  int quantidade;
  double preco;
  int categoriaId; // <- nova associação

  Produto({
    this.id,
    required this.nome,
    required this.quantidade,
    required this.preco,
    required this.categoriaId,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'nome': nome,
    'quantidade': quantidade,
    'preco': preco,
    'categoriaId': categoriaId, // <- salva a relação
  };

  static Produto fromMap(Map<String, dynamic> map) => Produto(
    id: map['id'],
    nome: map['nome'],
    quantidade: map['quantidade'],
    preco: map['preco'],
    categoriaId: map['categoriaId'], // <- recupera a relação
  );
}
