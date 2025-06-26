import 'package:sqflite/sqflite.dart';
import 'package:listacompras/banco/sqlite/conexao.dart';
import 'package:listacompras/models/roupa.dart';

class DAORoupa {
  final String _sqlInserir = '''
    INSERT OR REPLACE INTO roupas (id, nomeRoupa, tamanho, cor, dataCompra, preco)
    VALUES (?, ?, ?, ?, ?, ?)
  ''';

  final String _sqlAtualizar = '''
    UPDATE roupas SET 
      nomeRoupa = ?, tamanho = ?, cor = ?, dataCompra = ?, preco = ?
    WHERE id = ?
  ''';

  final String _sqlConsultarTodos = 'SELECT * FROM roupas';

  final String _sqlConsultarPorId = 'SELECT * FROM roupas WHERE id = ?';

  final String _sqlExcluir = 'DELETE FROM roupas WHERE id = ?';

  Future<void> salvar(Roupa roupa) async {
    final db = await Conexao.get();
    await db.rawInsert(_sqlInserir, [
      roupa.id,
      roupa.nomeRoupa,
      roupa.tamanho,
      roupa.marca,
      roupa.preco,
    ]);
  }

  Future<void> atualizar(Roupa roupa) async {
    final db = await Conexao.get();
    await db.rawUpdate(_sqlAtualizar, [
      roupa.nomeRoupa,
      roupa.tamanho,
      roupa.marca,
      roupa.preco,
      roupa.id,
    ]);
  }

  Future<void> excluir(int id) async {
    final db = await Conexao.get();
    await db.rawDelete(_sqlExcluir, [id]);
  }

  Future<List<Roupa>> consultarTodos() async {
    final db = await Conexao.get();
    final List<Map<String, dynamic>> maps = await db.rawQuery(_sqlConsultarTodos);
    return maps.map(_fromMap).toList();
  }

  Future<Roupa?> consultarPorId(int id) async {
    final db = await Conexao.get();
    final List<Map<String, dynamic>> maps = await db.rawQuery(_sqlConsultarPorId, [id]);
    if (maps.isNotEmpty) {
      return _fromMap(maps.first);
    }
    return null;
  }

  Roupa _fromMap(Map<String, dynamic> map) {
    return Roupa(
      id: map['id'] as int,
      nomeRoupa: map['nomeRoupa'] as String,
      tamanho: map['tamanho'] as String,
      marca: map['marca'] as String,
      preco: map['preco'] as double,
    );
  }
}
