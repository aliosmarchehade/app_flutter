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
    CREATE TABLE produtos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      quantidade INTEGER NOT NULL,
      preco REAL NOT NULL
    )
    '''
  ];

  static List<List<String>> comandosInsercoes = [
    [
      "INSERT INTO categoria (nome, descricao) VALUES ('Sobremesa', 'Doces em geral');",
      "INSERT INTO categoria (nome, descricao) VALUES ('Prato principal', 'Almoço ou jantar');",
    ],
    [],
    [],
    [],
  ];
}
