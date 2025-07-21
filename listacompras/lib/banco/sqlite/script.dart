class ScriptSQLite {
  static List<String> criarTabelas = [
    '''
    CREATE TABLE compras (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nomeProduto TEXT,
      dataCompra TEXT,
      quantidade INTEGER,
      precoTotal REAL
    )
    ''',
    '''
    CREATE TABLE roupas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nomeRoupa TEXT,
      tamanho TEXT,
      marca TEXT,
      preco REAL
    )
    ''',
    '''
    CREATE TABLE medicamento (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nomeMedicamento TEXT,
      dosagem TEXT,
      fabricante TEXT,
      preco REAL
    )
    ''',
    '''

    CREATE TABLE categoria (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      descricao TEXT
    )
    ''',
    '''
    CREATE TABLE produtos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      preco REAL NOT NULL,
      categoriaId INTEGER,
      FOREIGN KEY(categoriaId) REFERENCES categoria(id)
    )
    '''
  ];

  static List<List<String>> comandosInsercoes = [
    [
    ],
    [],
    [],
    [],
  ];
}
