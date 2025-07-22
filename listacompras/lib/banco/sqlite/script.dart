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
    // Inserções para a tabela compras 
    [],

    // Inserções para a tabela roupas
    [],

    // Inserções para a tabela medicamento
    [],

    // Inserções para a tabela categoria
    [
      '''INSERT INTO categoria (nome, descricao) VALUES ('Supermercado', 'Alimentos e produtos de uso doméstico')''',
      '''INSERT INTO categoria (nome, descricao) VALUES ('Petshop', 'Produtos e serviços para animais')''',
      '''INSERT INTO categoria (nome, descricao) VALUES ('Farmácia', 'Medicamentos e produtos de saúde')''',
      '''INSERT INTO categoria (nome, descricao) VALUES ('Roupas', 'Vestuário masculino e feminino')''',
      '''INSERT INTO categoria (nome, descricao) VALUES ('Mecânica', 'Aparelhos e dispositivos eletrônicos')''',
      '''INSERT INTO categoria (nome, descricao) VALUES ('Eletrônicos', 'Aparelhos e dispositivos eletrônicos')''',
    ],
  ];
}