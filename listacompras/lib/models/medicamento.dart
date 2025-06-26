class Medicamento {
  int? id;
  String nomeMedicamento;
  String? dosagem;
  String? fabricante;
  double? preco;

  Medicamento({
    this.id,
    required this.nomeMedicamento,
    this.dosagem,
    this.fabricante,
    this.preco,
  });
}
