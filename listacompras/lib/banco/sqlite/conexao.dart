import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'script.dart'; // Certifique-se de que `criarTabelas` está aqui

class Conexao {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _inicializarBanco();
    return _db!;
  }

  static Future<Database> _inicializarBanco() async {
    // Definindo a factory conforme a plataforma
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    // Definindo o caminho do banco
    String path;
    if (kIsWeb) {
      path = 'compras.db';
    } else {
      final databasesPath = await databaseFactory.getDatabasesPath();
      path = join(databasesPath, 'compras.db');
    }
    // deleteDatabase(path);
    // Abrindo ou criando o banco de dados
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _criarTabelas,
        onUpgrade: _atualizarBanco,
      ),
    );
  }

   static Future<void> _criarTabelas(Database db, int version) async {
    for (String comando in ScriptSQLite.criarTabelas) {
      await db.execute(comando);
    }

    for (List<String> insercoes in ScriptSQLite.comandosInsercoes) {
      for (String comando in insercoes) {
        await db.execute(comando);
      }
    }
  }
  static Future<void> _atualizarBanco(Database db, int oldVersion, int newVersion) async {
    // Lógica futura de migração de schema (versão)
  }

  static Future<void> fechar() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
