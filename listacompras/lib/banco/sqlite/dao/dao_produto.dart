import 'package:listacompras/banco/sqlite/conexao.dart';
import 'package:listacompras/models/produto.dart';

class ProdutoDAO {
  static const String _tabela = 'produtos';

  // Inserir ou atualizar
  Future<int> salvar(Produto produto) async {
    final db = await Conexao.database;

    final dados = {
      'nome': produto.nome,
      'preco': produto.preco,
      'categoriaId': produto.categoriaId,
    };

    if (produto.id != null) {
      return await db.update(
        _tabela,
        dados,
        where: 'id = ?',
        whereArgs: [produto.id],
      );
    } else {
      return await db.insert(_tabela, dados);
    }
  }

  // Buscar todos
  Future<List<Produto>> buscarTodos() async {
    final db = await Conexao.database;
    final List<Map<String, dynamic>> maps = await db.query(_tabela);

    return List.generate(maps.length, (i) {
      return Produto(
        id: maps[i]['id'],
        nome: maps[i]['nome'],
        preco: maps[i]['preco'],
        categoriaId: maps[i]['categoriaId'],
      );
    });
  }

  // Buscar por ID
  Future<Produto?> buscarPorId(int id) async {
    final db = await Conexao.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Produto(
        id: maps[0]['id'],
        nome: maps[0]['nome'],
        preco: maps[0]['preco'],
        categoriaId: maps[0]['categoriaId'],
      );
    }
    return null;
  }

  // Excluir
  Future<int> excluir(int id) async {
    final db = await Conexao.database;
    return await db.delete(
      _tabela,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
