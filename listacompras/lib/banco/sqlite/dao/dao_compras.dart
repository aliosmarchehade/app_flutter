import 'package:listacompras/banco/sqlite/conexao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:listacompras/models/compra.dart';

class DAOCompra {
  final String _sqlSalvar = '''
    INSERT OR REPLACE INTO compras (id, nomeProduto, dataCompra, quantidade, precoTotal, categoria, favorito)
    VALUES (?, ?, ?, ?, ?, ?, ?)
  ''';

  final String _sqlAtualizar = '''
    UPDATE compras SET 
      nomeProduto = ?, dataCompra = ?, quantidade = ?, precoTotal = ?, categoria = ?, favorito = ?
    WHERE id = ?
  ''';

  final String _sqlConsultarTodos = '''
    SELECT * FROM compras
  ''';

  final String _sqlConsultarPorId = '''
    SELECT * FROM compras WHERE id = ?
  ''';

  final String _sqlConsultarPorCategoria = '''
    SELECT * FROM compras WHERE categoria = ?
  ''';

  final String _sqlExcluir = '''
    DELETE FROM compras WHERE id = ?
  ''';

  Future<Compra> _fromMap(Map<String, dynamic> map) async {
    return Compra(
      id: map['id'],
      nomeProduto: map['nomeProduto'] as String,
      dataCompra: DateTime.parse(map['dataCompra'] as String),
      quantidade: map['quantidade'] as int,
      precoTotal: map['precoTotal'] as double,
      categoria: map['categoria'] as String,
      favorito: (map['favorito'] ?? 0) == 1,
    );
  }

  Map<String, dynamic> _toMap(Compra compra) {
    return {
      'id': compra.id,
      'nomeProduto': compra.nomeProduto,
      'dataCompra': compra.dataCompra.toIso8601String(),
      'quantidade': compra.quantidade,
      'precoTotal': compra.precoTotal,
      'categoria': compra.categoria,
      'favorito': compra.favorito ? 1 : 0,
    };
  }

  Future<void> salvar(Compra compra) async {
    final db = await Conexao.database;
    try {
      await db.rawInsert(_sqlSalvar, [
        compra.id,
        compra.nomeProduto,
        compra.dataCompra.toIso8601String(),
        compra.quantidade,
        compra.precoTotal,
        compra.categoria,
        compra.favorito ? 1 : 0,
      ]);
    } catch (e) {
      throw Exception('Erro ao salvar compra: $e');
    }
  }

  Future<void> atualizar(Compra compra) async {
    final db = await Conexao.database;
    try {
      await db.rawUpdate(_sqlAtualizar, [
        compra.nomeProduto,
        compra.dataCompra.toIso8601String(),
        compra.quantidade,
        compra.precoTotal,
        compra.categoria,
        compra.favorito ? 1 : 0,
        compra.id,
      ]);
    } catch (e) {
      throw Exception('Erro ao atualizar compra: $e');
    }
  }

  Future<List<Compra>> consultarTodos() async {
    final db = await Conexao.database;
    try {
      final List<Map<String, dynamic>> maps = await db.rawQuery(_sqlConsultarTodos);
      return Future.wait(maps.map((map) => _fromMap(map)));
    } catch (e) {
      throw Exception('Erro ao consultar compras: $e');
    }
  }

  Future<List<Compra>> consultarPorCategoria(String categoria) async {
    final db = await Conexao.database;
    try {
      final List<Map<String, dynamic>> maps = await db.rawQuery(_sqlConsultarPorCategoria, [categoria]);
      return Future.wait(maps.map((map) => _fromMap(map)));
    } catch (e) {
      throw Exception('Erro ao consultar por categoria: $e');
    }
  }

  Future<Compra?> consultarPorId(int id) async {
    final db = await Conexao.database;
    try {
      final List<Map<String, dynamic>> maps = await db.rawQuery(_sqlConsultarPorId, [id]);
      if (maps.isNotEmpty) {
        return await _fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao consultar compra por ID: $e');
    }
  }

  Future<void> excluir(int id) async {
    final db = await Conexao.database;
    try {
      await db.rawDelete(_sqlExcluir, [id]);
    } catch (e) {
      throw Exception('Erro ao excluir compra: $e');
    }
  }
}
