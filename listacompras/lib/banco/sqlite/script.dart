const criarTabelas = [
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
    cor TEXT,
    dataCompra TEXT,
    preco REAL
  )
  '''
'''
  CREATE TABLE medicamento (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nomeMedicamento TEXT,
    dosagem TEXT,
    fabricante TEXT,
    preco REAL
  )
  '''
];
