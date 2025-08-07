class Genero {
  int? id;
  String nomeGenero;

  Genero({this.id, required this.nomeGenero});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomeGenero': nomeGenero,
    };
  }

  factory Genero.fromMap(Map<String, dynamic> map) {
    return Genero(
      id: map['id'],
      nomeGenero: map['nomeGenero'],
    );
  }
}