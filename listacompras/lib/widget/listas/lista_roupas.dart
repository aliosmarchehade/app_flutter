import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listacompras/banco/sqlite/dao/dao_roupa.dart';
import 'package:listacompras/models/roupa.dart';
import 'package:listacompras/widget/FormRoupas.dart'; // ajuste se o caminho for diferente

class ListaRoupasScreen extends StatefulWidget {
  const ListaRoupasScreen({super.key});

  @override
  State<ListaRoupasScreen> createState() => _ListaRoupasScreenState();
}

class _ListaRoupasScreenState extends State<ListaRoupasScreen> {
  final DAORoupa _dao = DAORoupa();
  List<Roupa> _roupas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    _roupas = await _dao.consultarTodos();
    setState(() => _carregando = false);
  }

  Future<void> _excluir(Roupa roupa) async {
    await _dao.excluir(roupa.id!);
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roupas Cadastradas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregar,
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _roupas.isEmpty
              ? const Center(child: Text('Nenhuma roupa cadastrada'))
              : ListView.builder(
                  itemCount: _roupas.length,
                  itemBuilder: (context, index) => _itemLista(_roupas[index]),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormRoupas()),
          );
          _carregar();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _itemLista(Roupa roupa) {
    return ListTile(
      leading: const Icon(Icons.checkroom),
      title: Text(roupa.nomeRoupa),
      subtitle: Text(
        'Marca: ${roupa.marca ?? 'N/A'} • Tamanho: ${roupa.tamanho}\n'
        'Preço: R\$ ${roupa.preco?.toStringAsFixed(2)}',
      ),
      isThreeLine: true,
      trailing: Wrap(
        spacing: 12,
        children: [
          IconButton(
            icon: Icon(
              roupa.favorito ? Icons.star : Icons.star_border,
              color: roupa.favorito ? Colors.amber : Colors.grey,
            ),
            onPressed: () async {
              final novaRoupa = Roupa(
                id: roupa.id,
                nomeRoupa: roupa.nomeRoupa,
                tamanho: roupa.tamanho,
                marca: roupa.marca,
                preco: roupa.preco,
                favorito: !roupa.favorito,
              );
              await _dao.salvar(novaRoupa);

              setState(() {
                final index = _roupas.indexWhere((r) => r.id == roupa.id);
                if (index != -1) {
                  _roupas[index] = novaRoupa;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _excluir(roupa),
          ),
        ],
      ),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const FormRoupas(),
            settings: RouteSettings(arguments: roupa),
          ),
        );
        _carregar();
      },
    );
  }
}
