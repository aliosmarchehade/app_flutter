import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../banco/sqlite/dao/dao_produto.dart';
import '../../banco/sqlite/dao/dao_categoria.dart';
import '../../banco/sqlite/dao/dao_compras.dart';
import '../../models/produto.dart';
import '../../models/categoria.dart';
import '../../models/compra.dart';

class FormCompraSupermercado extends StatefulWidget {
  const FormCompraSupermercado({super.key});

  @override
  State<FormCompraSupermercado> createState() => _FormCompraSupermercadoState();
}

class _FormCompraSupermercadoState extends State<FormCompraSupermercado> {
  final _formKey = GlobalKey<FormState>();
  final _daoCompra = DAOCompra();
  final _daoProduto = ProdutoDAO();
  final _daoCategoria = CategoriaDAO();

  final _quantidadeController = TextEditingController();
  final _dataController = TextEditingController();

  DateTime _dataCompra = DateTime.now();

  List<Categoria> _categorias = [];
  Categoria? _categoriaSelecionada;

  List<Produto> _produtosFiltrados = [];
  Produto? _produtoSelecionado;

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
    _dataController.text = DateFormat('dd/MM/yyyy').format(_dataCompra);
  }

  void _carregarCategorias() async {
    final categorias = await _daoCategoria.buscarTodas();
    setState(() {
      _categorias = categorias;
    });
  }

  void _carregarProdutosPorCategoria(int categoriaId) async {
    final todosProdutos = await _daoProduto.buscarTodos();
    setState(() {
      _produtosFiltrados = todosProdutos
          .where((produto) => produto.categoriaId == categoriaId)
          .toList();
      _produtoSelecionado = null;
    });
  }

  Future<void> _selecionarData() async {
    final dataEscolhida = await showDatePicker(
      context: context,
      initialDate: _dataCompra,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Selecione a data da compra',
      cancelText: 'Cancelar',
      confirmText: 'Selecionar',
    );
    if (dataEscolhida != null) {
      setState(() {
        _dataCompra = dataEscolhida;
        _dataController.text = DateFormat('dd/MM/yyyy').format(_dataCompra);
      });
    }
  }

  void _salvar() async {
    if (_formKey.currentState!.validate() && _produtoSelecionado != null) {
      final quantidade = int.tryParse(_quantidadeController.text) ?? 1;
      final precoTotal = _produtoSelecionado!.preco * quantidade;

      final novaCompra = Compra(
        nomeProduto: _produtoSelecionado!.nome,
        dataCompra: _dataCompra,
        quantidade: quantidade,
        precoTotal: precoTotal,
      );

      await _daoCompra.salvar(novaCompra);
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _quantidadeController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Compra - Supermercado'),
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
          child: ListView(
            children: [
              DropdownButtonFormField<Categoria>(
                decoration: const InputDecoration(labelText: 'Categoria'),
                value: _categoriaSelecionada,
                items: _categorias.map((categoria) {
                  return DropdownMenuItem(
                    value: categoria,
                    child: Text(categoria.nome),
                  );
                }).toList(),
                onChanged: (novaCategoria) {
                  setState(() {
                    _categoriaSelecionada = novaCategoria;
                  });
                  if (novaCategoria != null) {
                    _carregarProdutosPorCategoria(novaCategoria.id!);
                  }
                },
                validator: (value) =>
                    value == null ? 'Selecione uma categoria' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Produto>(
                decoration: const InputDecoration(labelText: 'Produto'),
                value: _produtoSelecionado,
                items: _produtosFiltrados.map((produto) {
                  return DropdownMenuItem(
                    value: produto,
                    child: Text('${produto.nome} - R\$ ${produto.preco.toStringAsFixed(2)}'),
                  );
                }).toList(),
                onChanged: (novoProduto) {
                  setState(() {
                    _produtoSelecionado = novoProduto;
                  });
                },
                validator: (value) =>
                    value == null ? 'Selecione um produto' : null,
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
              const SizedBox(height: 12),
              TextFormField(
                controller: _dataController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Data da Compra',
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                ),
                onTap: _selecionarData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
