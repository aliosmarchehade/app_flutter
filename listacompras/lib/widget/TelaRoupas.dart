import 'package:flutter/material.dart';
import 'package:listacompras/models/roupa.dart';
import 'package:listacompras/banco/sqlite/dao/dao_roupa.dart';
import 'package:listacompras/validacoes/validadorMercado.dart';

class TelaRoupas extends StatefulWidget {
  const TelaRoupas({super.key});

  @override
  State<TelaRoupas> createState() => _TelaRoupasState();
}

class _TelaRoupasState extends State<TelaRoupas> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _tamanhoController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();

  final DAORoupa _dao = DAORoupa();
  List<Roupa> _itens = [];
  int? _itemSelecionadoIndex;
  int? _hoverdIndex;

  @override
  void initState() {
    super.initState();
    _carregarRoupas();
  }

  Future<void> _carregarRoupas() async {
    final roupas = await _dao.consultarTodos();
    setState(() {
      _itens = roupas;
    });
  }

  void _mostrarErro(String mensagem) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erro'),
        content: Text(mensagem),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  Future<void> _adicionarItem() async {
    final nome = _nomeController.text.trim();

    if (!ValidadorItem.ehValido(nome)) {
      _mostrarErro('Nome inválido.');
      return;
    }

    final novaRoupa = Roupa(
      nomeRoupa: nome,
      tamanho: _tamanhoController.text,
      marca: _marcaController.text,
      preco: double.tryParse(_precoController.text) ?? 0.0,
    );

    await _dao.salvar(novaRoupa);
    _limparCampos();
    _carregarRoupas();
  }

  Future<void> _editarItem() async {
    if (_itemSelecionadoIndex == null) return;

    final roupa = _itens[_itemSelecionadoIndex!];
    final nome = _nomeController.text.trim();

    if (!ValidadorItem.ehValido(nome)) {
      _mostrarErro('Nome inválido.');
      return;
    }

    final roupaAtualizada = Roupa(
      id: roupa.id,
      nomeRoupa: nome,
      tamanho: _tamanhoController.text,
      marca: _marcaController.text,
      preco: double.tryParse(_precoController.text) ?? 0.0,
    );

    await _dao.atualizar(roupaAtualizada);
    _limparCampos();
    _carregarRoupas();
  }

  Future<void> _excluirItem() async {
    if (_itemSelecionadoIndex == null) return;

    final roupa = _itens[_itemSelecionadoIndex!];

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Excluir "${roupa.nomeRoupa}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (confirm == true) {
      await _dao.excluir(roupa.id!);
      _limparCampos();
      _carregarRoupas();
    }
  }

  void _selecionarItem(int index) {
    final roupa = _itens[index];
    setState(() {
      _itemSelecionadoIndex = index;
      _nomeController.text = roupa.nomeRoupa;
      _tamanhoController.text = roupa.tamanho ?? '';
      _marcaController.text = roupa.marca ?? '';
      _precoController.text = roupa.preco?.toStringAsFixed(2) ?? '';
    });
  }

  void _limparCampos() {
    _nomeController.clear();
    _tamanhoController.clear();
    _marcaController.clear();
    _precoController.clear();
    _itemSelecionadoIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de compra de Roupas'),
        backgroundColor: Colors.white,
      ),
      body: Row(
        children: [
          // Lista
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                itemCount: _itens.length,
                itemBuilder: (context, index) {
                  final isSelected = _itemSelecionadoIndex == index;
                  final isHovered = _hoverdIndex == index;
                  final roupa = _itens[index];

                  return ListTile(
                    tileColor: isSelected ? Colors.green.withOpacity(0.2) : null,
                    onTap: () => _selecionarItem(index),
                    title: MouseRegion(
                      onEnter: (_) => setState(() => _hoverdIndex = index),
                      onExit: (_) => setState(() => _hoverdIndex = null),
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        roupa.nomeRoupa,
                        style: TextStyle(
                          decoration: isHovered ? TextDecoration.underline : null,
                          color: isHovered ? Colors.black : Colors.black87,
                          fontWeight: isHovered ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    subtitle: Text('Marca: ${roupa.marca ?? '---'} | Tam: ${roupa.tamanho ?? '---'}'),
                    trailing: Text('R\$ ${roupa.preco?.toStringAsFixed(2) ?? '0.00'}'),
                  );
                },
              ),
            ),
          ),

          // Formulário
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Gerenciar Roupas:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nomeController,
                    decoration: const InputDecoration(labelText: 'Nome da Roupa', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _tamanhoController,
                    decoration: const InputDecoration(labelText: 'Tamanho', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _marcaController,
                    decoration: const InputDecoration(labelText: 'Marca', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _precoController,
                    decoration: const InputDecoration(labelText: 'Preço', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _adicionarItem,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar'),
                    style: ElevatedButton.styleFrom(foregroundColor: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _editarItem,
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                    style: ElevatedButton.styleFrom(foregroundColor: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _excluirItem,
                    icon: const Icon(Icons.delete),
                    label: const Text('Excluir'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
