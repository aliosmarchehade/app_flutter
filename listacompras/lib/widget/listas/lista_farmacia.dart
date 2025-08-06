import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../banco/sqlite/dao/dao_compras.dart';
import '../../models/compra.dart';
import '../../../configuracao/rotas.dart'; // adapte se o nome da rota for diferente

class LisaFarmaciaScreen extends StatefulWidget {
  const LisaFarmaciaScreen({super.key});

  @override
  State<LisaFarmaciaScreen> createState() => _LisaFarmaciaScreenState();
}

class _LisaFarmaciaScreenState extends State<LisaFarmaciaScreen> {
  final DAOCompra _dao = DAOCompra();
  List<Compra> _compras = [];
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
        title: const Text('Compras da Farmácia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregar,
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _compras.isEmpty
              ? const Center(child: Text('Nenhuma compra registrada'))
              : ListView.builder(
                  itemCount: _compras.length,
                  itemBuilder: (context, index) =>
                      _itemLista(_compras[index]),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          Rotas.farmacia, // ajuste conforme a rota definida
        ).then((_) => _carregar()),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _itemLista(Compra compra) {
    return ListTile(
      leading: const Icon(Icons.local_pharmacy),
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
              );
              await _dao.salvar(novaCompra);

              setState(() {
                final index = _compras.indexWhere((c) => c.id == compra.id);
                if (index != -1) {
                  _compras[index] = novaCompra;
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
          Rotas.farmacia, // rota do formulário
          arguments: compra, // edição
        ).then((_) => _carregar());
      },
    );
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    _compras = await _dao.consultarPorCategoria("farmacia");
    setState(() => _carregando = false);
  }

  Future<void> _excluir(Compra compra) async {
    await _dao.excluir(compra.id!);
    _carregar();
  }
}
