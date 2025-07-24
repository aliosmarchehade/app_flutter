class Favorito {
  int? id;
  String nome;

  Favorito({this.id, required this.nome});

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
    };
  }

  static Favorito fromMap(Map<String, dynamic> map) {
    return Favorito(
      id: map['id'],
      nome: map['nome'],
    );
  }
}
