import 'package:listacompras/banco/sqlite/conexao.dart';
import 'package:listacompras/models/categoria.dart';

class CategoriaDAO {
  static const String _tabela = 'categoria';

  Future<List<Categoria>> buscarTodas() async {
    final db = await Conexao.database;
    final maps = await db.query(_tabela);

    return List.generate(maps.length, (i) {
      final map = maps[i];
      return Categoria(
        id: map['id'] as int,
        nome: map['nome'].toString(),
        descricao: map['descricao'].toString(),
      );
    });
  }

  Future<void> salvar(Categoria categoria) async {
  final db = await Conexao.database;

  if (categoria.id == null) {
    // Inserir nova categoria
    await db.insert(
      _tabela,
      {
        'nome': categoria.nome,
        'descricao': categoria.descricao,
      },
    );
  } else {
    // Atualizar categoria existente
    await db.update(
      _tabela,
      {
        'nome': categoria.nome,
        'descricao': categoria.descricao,
      },
      where: 'id = ?',
      whereArgs: [categoria.id],
    );
  }
  }
}
