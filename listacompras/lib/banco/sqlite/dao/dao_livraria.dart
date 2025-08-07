
import 'package:listacompras/banco/sqlite/script.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:listacompras/models/genero.dart';

class DAOLivraria {
  static final DAOLivraria instance = DAOLivraria._init();
  static Database? _database;

  DAOLivraria._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('livraria.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      for (var tabela in ScriptSQLite.criarTabelas) {
        await db.execute(tabela);
      }
      for (var insercoes in ScriptSQLite.comandosInsercoes) {
        for (var comando in insercoes) {
          await db.execute(comando);
        }
      }
    }, onUpgrade: (db, oldVersion, newVersion) async {
      // Opcional: recriar tabelas se a versão mudar
      await db.execute('DROP TABLE IF EXISTS generos');
      await db.execute('DROP TABLE IF EXISTS livros');
      for (var tabela in ScriptSQLite.criarTabelas) {
        await db.execute(tabela);
      }
      for (var insercoes in ScriptSQLite.comandosInsercoes) {
        for (var comando in insercoes) {
          await db.execute(comando);
        }
      }
    });
  }

  Future<int> salvar(Genero genero) async {
    final db = await database;
    return await db.insert('generos', genero.toMap());
  }

  Future<List<Genero>> listar() async {
    final db = await database;
    final result = await db.query('generos');
    return result.map((map) => Genero.fromMap(map)).toList();
  }
}
