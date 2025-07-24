import 'package:listacompras/banco/sqlite/conexao.dart';
import 'package:listacompras/models/produtoFavorito.dart';

class ProdutoFavoritoDAO {
  static const String _tabela = 'produto_favorito';

  Future<void> adicionar(ProdutoFavorito pf) async {
    final db = await Conexao.database;
    await db.insert(_tabela, pf.toMap());
  }

  Future<void> remover(ProdutoFavorito pf) async {
    final db = await Conexao.database;
    await db.delete(
      _tabela,
      where: 'produtoId = ? AND favoritoId = ?',
      whereArgs: [pf.produtoId, pf.favoritoId],
    );
  }

  Future<List<int>> buscarProdutosFavoritos(int favoritoId) async {
    final db = await Conexao.database;
    final maps = await db.query(
      _tabela,
      where: 'favoritoId = ?',
      whereArgs: [favoritoId],
    );

    return List.generate(maps.length, (i) => maps[i]['produtoId'] as int);
  }
}
