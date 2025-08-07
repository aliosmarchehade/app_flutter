  class ScriptSQLite {
    static List<String> criarTabelas = [
      // Tabela de compras
      '''
      CREATE TABLE compras (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomeProduto TEXT,
        dataCompra TEXT,
        quantidade INTEGER,
        precoTotal REAL,
        categoria TEXT,
        favorito INTEGER DEFAULT 0,
        tipoVeiculo TEXT
      )
      ''',

      // Tabela de roupas
      '''
      CREATE TABLE roupas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomeRoupa TEXT,
        tamanho TEXT,
        marca TEXT,
        preco REAL,
        favorito INTEGER DEFAULT 0
      )
      ''',

      // Tabela favorito (separado)
      '''
      CREATE TABLE favorito (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL
      )
      ''',

      // Tabela produto_favorito (separado)
      '''
      CREATE TABLE produto_favorito (
        produtoId INTEGER NOT NULL,
        favoritoId INTEGER NOT NULL,
        PRIMARY KEY (produtoId, favoritoId)
        -- Você pode adicionar FOREIGN KEYs aqui se quiser referenciar as tabelas específicas
      )
      ''',

      // Tabela de categorias
      '''
      CREATE TABLE categoria (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        descricao TEXT
      )
      ''',

      // Tabela de produtos
      '''
      CREATE TABLE produtos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        preco REAL NOT NULL,
        categoriaId INTEGER,
        FOREIGN KEY(categoriaId) REFERENCES categoria(id)
      )
      ''',

      // Tabela de gêneros literários
      '''
      CREATE TABLE generos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomeGenero TEXT NOT NULL
      )
      ''',

      // Tabela de livros (com coluna favorito)
      '''
      CREATE TABLE livros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        autor TEXT,
        preco REAL NOT NULL,
        generoId INTEGER,
        favorito INTEGER DEFAULT 0,
        FOREIGN KEY(generoId) REFERENCES generos(id)
      )
      '''
    ];

    static List<List<String>> comandosInsercoes = [
      // Inserções para a tabela compras
      [],

      // Inserções para a tabela roupas
      [],

      // Inserções para a tabela medicamento (não há tabela no script atual)
      [],

      // Inserções para a tabela categoria
      [
        '''INSERT INTO categoria (nome, descricao) VALUES ('Supermercado', 'Alimentos e produtos de uso doméstico')''',
        '''INSERT INTO categoria (nome, descricao) VALUES ('Petshop', 'Produtos e serviços para animais')''',
        '''INSERT INTO categoria (nome, descricao) VALUES ('Farmácia', 'Medicamentos e produtos de saúde')''',
        '''INSERT INTO categoria (nome, descricao) VALUES ('Roupas', 'Vestuário masculino e feminino')''',
        '''INSERT INTO categoria (nome, descricao) VALUES ('Mecanica', 'Serviços automotivos')''',
        '''INSERT INTO categoria (nome, descricao) VALUES ('Eletrônicos', 'Aparelhos e dispositivos eletrônicos')'''
      ],

      // Inserções para a tabela generos
      [
      
      ],
    ];
  }
