import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../banco/sqlite/dao/dao_compras.dart';
import '../../models/compra.dart';
import '../../../configuracao/rotas.dart';

class ListaMecanicaScreen extends StatefulWidget {
  const ListaMecanicaScreen({super.key});

  @override
  State<ListaMecanicaScreen> createState() => _ListaMecanicaScreenState();
}

class _ListaMecanicaScreenState extends State<ListaMecanicaScreen> {
  final DAOCompra _dao = DAOCompra();
  Map<String, List<Compra>> _comprasPorTipoVeiculo = {};
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    final todasCompras = await _dao.consultarPorCategoria('mecanica');

    final Map<String, List<Compra>> agrupadas = {};

    for (var compra in todasCompras) {
      final tipo = compra.tipoVeiculo ?? 'Outro';
      agrupadas.putIfAbsent(tipo, () => []);
      agrupadas[tipo]!.add(compra);
    }

    setState(() {
      _comprasPorTipoVeiculo = agrupadas;
      _carregando = false;
    });
  }

  Future<void> _excluir(Compra compra) async {
    await _dao.excluir(compra.id!);
    await _carregar();
  }

  Widget _itemLista(Compra compra) {
    return ListTile(
      leading: const Icon(Icons.build),
      title: Text(compra.nomeProduto),
      subtitle: Text(
        'Qtd: ${compra.quantidade} • Total: R\$ ${compra.precoTotal.toStringAsFixed(2)}\n'
        'Data: ${DateFormat('dd/MM/yyyy').format(compra.dataCompra)}',
      ),
      isThreeLine: true,
      trailing: Wrap(
        spacing: 12,
        children: [
          IconButton(
            icon: Icon(
              compra.favorito ? Icons.star : Icons.star_border,
              color: compra.favorito ? Colors.amber : Colors.grey,
            ),
            onPressed: () async {
              final novaCompra = Compra(
                id: compra.id,
                nomeProduto: compra.nomeProduto,
                quantidade: compra.quantidade,
                precoTotal: compra.precoTotal,
                dataCompra: compra.dataCompra,
                categoria: compra.categoria,
                favorito: !compra.favorito,
                tipoVeiculo: compra.tipoVeiculo,
              );
              await _dao.salvar(novaCompra);

              setState(() {
                final index = _comprasPorTipoVeiculo[tipoVeiculoKey(compra.tipoVeiculo)]?.indexWhere((c) => c.id == compra.id) ?? -1;
                if (index != -1) {
                  _comprasPorTipoVeiculo[tipoVeiculoKey(compra.tipoVeiculo)]![index] = novaCompra;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _excluir(compra),
          ),
        ],
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          Rotas.mecanica, // sua rota para formulário mecânica
          arguments: compra,
        ).then((_) => _carregar());
      },
    );
  }

  String tipoVeiculoKey(String? tipo) => tipo ?? 'Outro';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compras - Mecânica'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregar,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Rotas.mecanica)
              .then((_) => _carregar());
        },
        child: const Icon(Icons.add),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _comprasPorTipoVeiculo.isEmpty
              ? const Center(child: Text('Nenhuma compra registrada'))
              : ListView(
                  children: _comprasPorTipoVeiculo.entries.map((entry) {
                    final tipoVeiculo = entry.key;
                    final compras = entry.value;

                    return ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(
                        tipoVeiculo.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: compras.map(_itemLista).toList(),
                    );
                  }).toList(),
                ),
    );
  }
}
