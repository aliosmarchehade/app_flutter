import 'package:listacompras/banco/sqlite/conexao.dart';
import 'package:listacompras/models/favorito.dart';

class FavoritoDAO {
  static const String _tabela = 'favorito';

  Future<int> inserir(Favorito favorito) async {
    final db = await Conexao.database;
    return await db.insert(_tabela, favorito.toMap());
  }

  Future<List<Favorito>> buscarTodos() async {
    final db = await Conexao.database;
    final maps = await db.query(_tabela);

    return List.generate(maps.length, (i) {
      return Favorito.fromMap(maps[i]);
    });
  }

  Future<void> remover(int id) async {
    final db = await Conexao.database;
    await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }
}
