class Livro {
  int? id;
  String titulo;
  String? autor;
  double preco;
  int? generoId;
  bool favorito;

  Livro({
    this.id,
    required this.titulo,
    this.autor,
    required this.preco,
    this.generoId,
    this.favorito = false, // valor padrão
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'preco': preco,
      'generoId': generoId,
      'favorito': favorito ? 1 : 0, // armazenar como inteiro no SQLite
    };
  }

  factory Livro.fromMap(Map<String, dynamic> map) {
    return Livro(
      id: map['id'],
      titulo: map['titulo'],
      autor: map['autor'],
      preco: map['preco'],
      generoId: map['generoId'],
      favorito: map['favorito'] == 1, // interpretar como bool
    );
  }
}
