import 'package:flutter/material.dart';
import 'Produto.dart';

class ProdutoScreen extends StatefulWidget {
  const ProdutoScreen({Key? key}) : super(key: key);

  @override
  State<ProdutoScreen> createState() => _ProdutoScreenState();
}

class _ProdutoScreenState extends State<ProdutoScreen> {
  final List<Produto> _produtos = [];
  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _quantidadeController = TextEditingController();

  void _adicionarProduto() {
    setState(() {
      _produtos.add(Produto(
        nome: _nomeController.text,
        preco: double.tryParse(_precoController.text) ?? 0.0,
        quantidade: int.tryParse(_quantidadeController.text) ?? 0,
      ));
      _nomeController.clear();
      _precoController.clear();
      _quantidadeController.clear();
    });
  }

  void _removerProduto(int index) {
    setState(() {
      _produtos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CRUD de Produtos")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(controller: _nomeController, decoration: const InputDecoration(labelText: "Nome")),
            TextField(controller: _precoController, decoration: const InputDecoration(labelText: "Preço"), keyboardType: TextInputType.number),
            TextField(controller: _quantidadeController, decoration: const InputDecoration(labelText: "Quantidade"), keyboardType: TextInputType.number),
            ElevatedButton(onPressed: _adicionarProduto, child: const Text("Adicionar Produto")),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _produtos.length,
                itemBuilder: (context, index) {
                  final p = _produtos[index];
                  return ListTile(
                    title: Text(p.nome),
                    subtitle: Text("R\$ ${p.preco.toStringAsFixed(2)} • Qtde: ${p.quantidade}"),
                    trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => _removerProduto(index)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
