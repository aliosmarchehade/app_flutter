class Produto {
  int? id;
  String nome;
  int quantidade;
  double preco;

  Produto({
    this.id,
    required this.nome,
    required this.quantidade,
    required this.preco,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'nome': nome, 
    'quantidade': quantidade,
    'preco': preco,
  };

  static Produto fromMap(Map<String, dynamic> map) => Produto(
    id: map['id'],
    nome: map['nome'],
    quantidade: map['quantidade'],
    preco: map['preco'],
  );
}
