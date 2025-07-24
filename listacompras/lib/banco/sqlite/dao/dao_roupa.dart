import 'package:sqflite/sqflite.dart';
import 'package:listacompras/banco/sqlite/conexao.dart';
import 'package:listacompras/models/roupa.dart';

class DAORoupa {
  final String _sqlInserir = '''
  INSERT INTO roupas (nomeRoupa, tamanho, marca, preco, favorito)
  VALUES (?, ?, ?, ?, ?)
''';

  final String _sqlAtualizar = '''
  UPDATE roupas SET 
    nomeRoupa = ?, tamanho = ?, marca = ?, preco = ?, favorito = ?
  WHERE id = ?
''';

  final String _sqlConsultarTodos = 'SELECT * FROM roupas';

  final String _sqlConsultarPorId = 'SELECT * FROM roupas WHERE id = ?';

  final String _sqlExcluir = 'DELETE FROM roupas WHERE id = ?';

  Future<void> salvar(Roupa roupa) async {
    final db = await Conexao.database;
    try {
      if (roupa.id == null) {
        await db.rawInsert(_sqlInserir, [
          roupa.nomeRoupa,
          roupa.tamanho,
          roupa.marca,
          roupa.preco,
          roupa.favorito ? 1 : 0,
        ]);
        print('Roupa salva com sucesso: ${roupa.nomeRoupa}');
      } else {
        await db.rawUpdate(_sqlAtualizar, [
          roupa.nomeRoupa,
          roupa.tamanho,
          roupa.marca,
          roupa.preco,
          roupa.favorito ? 1 : 0,
          roupa.id,
        ]);
        print('Roupa atualizada com sucesso: ${roupa.nomeRoupa}');
      }
    } catch (e) {
      print('Erro ao salvar/atualizar roupa: $e');
    }
  }

  Future<void> atualizar(Roupa roupa) async {
    final db = await Conexao.database;
    await db.rawUpdate(_sqlAtualizar, [
      roupa.nomeRoupa,
      roupa.tamanho,
      roupa.marca,
      roupa.preco,
      roupa.favorito ? 1 : 0,
      roupa.id,
    ]);
  }

  Future<void> excluir(int id) async {
    final db = await Conexao.database;
    await db.rawDelete(_sqlExcluir, [id]);
  }

  Future<List<Roupa>> consultarTodos() async {
    final db = await Conexao.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(_sqlConsultarTodos);
    print('Roupas carregadas do banco: $maps');
    return maps.map(_fromMap).toList();
  }

  Future<Roupa?> consultarPorId(int id) async {
    final db = await Conexao.database;
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
      tamanho: map['tamanho'] as String?,
      marca: map['marca'] as String?,
      preco: (map['preco'] as num?)?.toDouble(),
      favorito: (map['favorito'] ?? 0) == 1,
    );
  }
}
