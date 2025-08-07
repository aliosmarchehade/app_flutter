import 'package:sqflite/sqflite.dart';
import 'package:listacompras/banco/sqlite/dao/dao_livraria.dart';
import 'package:listacompras/models/livro.dart';

class DAOLivro {
  static final DAOLivro instance = DAOLivro._init();
  static Database? _database;

  DAOLivro._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await DAOLivraria.instance.database;
    return _database!;
  }

  Future<int> salvar(Livro livro) async {
    final db = await database;
    if (livro.id == null) {
      return await db.insert('livros', livro.toMap());
    } else {
      return await db.update(
        'livros',
        livro.toMap(),
        where: 'id = ?',
        whereArgs: [livro.id],
      );
    }
  }

  Future<List<Livro>> listar() async {
    final db = await database;
    final result = await db.query('livros');
    return result.map((map) => Livro.fromMap(map)).toList();
  }

  Future<int> excluir(int id) async {
    final db = await database;
    return await db.delete(
      'livros',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Livro?> buscarPorId(int id) async {
    final db = await database;
    final result = await db.query(
      'livros',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Livro.fromMap(result.first);
    }
    return null;
  }
}
