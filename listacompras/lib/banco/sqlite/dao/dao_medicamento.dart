import 'package:listacompras/banco/sqlite/conexao.dart';
import 'package:listacompras/models/medicamento.dart';
import 'package:sqflite/sqflite.dart';

class DAOMedicamento {
  Future<Database> get _db async => await Conexao.database;

  Future<void> salvar(Medicamento medicamento) async {
    final db = await _db;
    await db.insert(
      'medicamento',
      {
        'nomeMedicamento': medicamento.nomeMedicamento,
        'dosagem': medicamento.dosagem,
        'fabricante': medicamento.fabricante,
        'preco': medicamento.preco,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> atualizar(Medicamento medicamento) async {
    final db = await _db;
    if (medicamento.id != null) {
      await db.update(
        'medicamento',
        {
          'nomeMedicamento': medicamento.nomeMedicamento,
          'dosagem': medicamento.dosagem,
          'fabricante': medicamento.fabricante,
          'preco': medicamento.preco,
        },
        where: 'id = ?',
        whereArgs: [medicamento.id],
      );
    }
  }

  Future<void> excluir(int id) async {
    final db = await _db;
    await db.delete('medicamento', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Medicamento>> consultarTodos() async {
    final db = await _db;
    final resultado = await db.query('medicamento');
    return resultado.map((mapa) {
      return Medicamento(
        id: mapa['id'] as int,
        nomeMedicamento: mapa['nomeMedicamento'] as String,
        dosagem: mapa['dosagem'] as String?,
        fabricante: mapa['fabricante'] as String?,
        preco: (mapa['preco'] as num?)?.toDouble(),
      );
    }).toList();
  }
}
