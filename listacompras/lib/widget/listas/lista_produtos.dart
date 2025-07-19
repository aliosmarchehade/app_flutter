import 'package:flutter/material.dart';
import '../../banco/sqlite/dao/dao_produto.dart';
import '../../models/produto.dart';
import '../../../configuracao/rotas.dart';

class ListaProdutosScreen extends StatefulWidget {
  const ListaProdutosScreen({super.key});

  @override
  State<ListaProdutosScreen> createState() => _ListaProdutosScreenState();
}

class _ListaProdutosScreenState extends State<ListaProdutosScreen> {
  final ProdutoDAO _dao = ProdutoDAO();
  List<Produto> _produtos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          IconButton(
            onPressed: _carregar,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _produtos.isEmpty
              ? const Center(child: Text('Nenhum produto cadastrado'))
              : ListView.builder(
                  itemCount: _produtos.length,
                  itemBuilder: (context, index) =>
                      _itemLista(_produtos[index]),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Rotas.produtos)
            .then((_) => _carregar()),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _itemLista(Produto produto) {
    return ListTile(
      leading: const Icon(Icons.shopping_cart),
      title: Text(produto.nome),
      subtitle: Text(
        'Preço: R\$ ${produto.preco.toStringAsFixed(2)} | Quantidade: ${produto.quantidade}',
      ),
      onTap: () => Navigator.pushNamed(
        context,
        Rotas.produtos,
        arguments: produto,
      ).then((_) => _carregar()),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => _excluir(produto),
      ),
    );
  }

    Future<void> _carregar() async {
    setState(() => _carregando = true);
    _produtos = await _dao.buscarTodos();
    setState(() => _carregando = false);
  }

  Future<void> _excluir(Produto produto) async {
    await _dao.excluir(produto.id!);
    _carregar();
  }
}
