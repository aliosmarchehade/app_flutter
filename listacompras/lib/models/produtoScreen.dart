import 'package:flutter/material.dart';
import '../../banco/sqlite/dao/dao_produto.dart';
import '../../models/produto.dart';

class FormProduto extends StatefulWidget {
  const FormProduto({super.key});

  @override
  State<FormProduto> createState() => _FormProdutoState();
}

class _FormProdutoState extends State<FormProduto> {
  final _formKey = GlobalKey<FormState>();
  final _dao = ProdutoDAO();

  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _quantidadeController = TextEditingController();

  int? _id;

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Produto) {
      _id = args.id;
      _nomeController.text = args.nome;
      _precoController.text = args.preco.toStringAsFixed(2);
      _quantidadeController.text = args.quantidade.toString();
    }
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final produto = Produto(
        id: _id,
        nome: _nomeController.text,
        preco: double.tryParse(_precoController.text) ?? 0.0,
        quantidade: int.tryParse(_quantidadeController.text) ?? 1,
      );
      await _dao.salvar(produto);
      if (!mounted) return;
      Navigator.of(context).pop(); // ✅ volta para a lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Editar Produto' : 'Novo Produto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _salvar,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Produto'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _precoController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  if (parsed == null || parsed < 0) return 'Preço inválido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantidadeController,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) return 'Quantidade inválida';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
