# Check 2 - CRUDs com Associação
foco nos relacionamentos entre entidades:

### 📌 Associação 1:N
 **Categoria ↔ Produto (1:N, associação clássica)** 
- `lib/models/categoria.dart`
- `lib/models/produto.dart`

- `lib/banco/sqlite/dao/dao_categoria.dart`
- `lib/banco/sqlite/dao/dao_produto.dart`

- `lib/widget/FormCategoria.dart`
- `lib/models/produtoScreen.dart`

- Uma categoria pode ter vários produtos (ex.: "Supermercado" → Água, Suco, Lasanha, Banana, Maçã).
- Mas cada produto pertence a apenas uma categoria.
- Ela está presente por enquanto no FormSupermercado e FormFarmacia.

 **Produto ↔ Compra (1:N, associação clássica)** 
- `lib/models/produto.dart`
- `lib/models/compra.dart`

- `lib/banco/sqlite/dao/dao_produto.dart`
- `lib/banco/sqlite/dao/dao_compras.dart`

- `lib/widget/FormFarmacia.dart`
- `lib/widget/FormSupermercado.dart`

- Uma compra se refere a um único produto, mas o mesmo produto pode aparecer em várias compras.
- Produto: "Coca-Cola 2L" → Compras: "5 unidades (20/07)", "3 unidades (25/07)".


### 📌 Associação N:N
 **Produto ↔ Favorito (N:N real, com tabela de associação)** 

- `lib/models/produto.dart`
- `lib/models/favorito.dart`
- `lib/models/produtoFavorito.dart`

- `lib/banco/sqlite/dao/dao_produto_favorito.dart`
- `lib/banco/sqlite/dao/dao_favorito.dart`
- `lib/banco/sqlite/dao/dao_produto.dart`

- `lib/widget/listas/lista_favoritos.dart`
- `lib/widget/listas/lista_compras_mercado.dart`
- `lib/widget/listas/lista_farmacia.dart`
- Essas duas ultimas são as listas onde são possiveis marcar os produtos como favoritos

- Um produto pode estar em vários “favoritos” (listas/usuários) e um “favorito” pode conter vários produtos.
Tabela de associação: produto_favorito
---