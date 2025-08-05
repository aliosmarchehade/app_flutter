import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../banco/sqlite/dao/dao_compras.dart';
import '../../banco/sqlite/dao/dao_roupa.dart';
import '../../models/compra.dart';
import '../../models/roupa.dart';

class ListaFavoritosScreen extends StatefulWidget {
  const ListaFavoritosScreen({super.key});

  @override
  State<ListaFavoritosScreen> createState() => _ListaFavoritosScreenState();
}

class _ListaFavoritosScreenState extends State<ListaFavoritosScreen> {
  final DAOCompra _daoCompra = DAOCompra();
  final DAORoupa _daoRoupa = DAORoupa();

  Map<String, List<dynamic>> _favoritosPorCategoria = {};
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
        title: const Text('Favoritos - Todas Categorias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregar,
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _favoritosPorCategoria.isEmpty
              ? const Center(child: Text('Nenhum item favoritado'))
              : ListView(
                  children: _favoritosPorCategoria.entries.map((entry) {
                    final categoria = entry.key;
                    final favoritos = entry.value;
                    return _blocoCategoria(categoria, favoritos);
                  }).toList(),
                ),
    );
  }

  Widget _blocoCategoria(String categoria, List<dynamic> favoritos) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        categoria.toUpperCase(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: favoritos.map((item) {
        return _tileGenerico(item);
      }).toList(),
    );
  }

  /// NOVO MÉTODO: retorna o ListTile correto com ícone por tipo
  Widget _tileGenerico(dynamic item) {
    if (item is Compra) {
      return ListTile(
        leading: const Icon(Icons.shopping_cart), // Ícone para Compra
        title: Text(item.nomeProduto),
        subtitle: Text(
          'Qtd: ${item.quantidade} • Total: R\$ ${item.precoTotal.toStringAsFixed(2)}\n'
          'Data: ${DateFormat('dd/MM/yyyy').format(item.dataCompra)}',
        ),
        trailing: IconButton(
          icon: Icon(
            item.favorito ? Icons.star : Icons.star_border,
            color: item.favorito ? Colors.amber : Colors.grey,
          ),
          onPressed: () async {
            final atualizado = Compra(
              id: item.id,
              nomeProduto: item.nomeProduto,
              quantidade: item.quantidade,
              precoTotal: item.precoTotal,
              dataCompra: item.dataCompra,
              categoria: item.categoria,
              favorito: !item.favorito,
            );
            await _daoCompra.salvar(atualizado);
            _carregar();
          },
        ),
      );
    } else if (item is Roupa) {
      return ListTile(
        leading: const Icon(Icons.checkroom), // Ícone para Roupa
        title: Text(item.nomeRoupa),
        subtitle: Text(
          'Marca: ${item.marca ?? 'N/A'} • Tamanho: ${item.tamanho}\n'
          'Preço: R\$ ${item.preco?.toStringAsFixed(2)}',
        ),
        trailing: IconButton(
          icon: Icon(
            item.favorito ? Icons.star : Icons.star_border,
            color: item.favorito ? Colors.amber : Colors.grey,
          ),
          onPressed: () async {
            final atualizado = Roupa(
              id: item.id,
              nomeRoupa: item.nomeRoupa,
              tamanho: item.tamanho,
              marca: item.marca,
              preco: item.preco,
              favorito: !item.favorito,
            );
            await _daoRoupa.salvar(atualizado);
            _carregar();
          },
        ),
      );
    } else {
      return const ListTile(
        title: Text('Tipo não suportado'),
        leading: Icon(Icons.help_outline),
      );
    }
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);

    final compras = await _daoCompra.consultarTodos();
    final roupas = await _daoRoupa.consultarTodos();

    final favoritosCompras = compras.where((c) => c.favorito).toList();
    final favoritosRoupas = roupas.where((r) => r.favorito).toList();

    final Map<String, List<dynamic>> agrupados = {};

    // Agrupar por categoria das compras
    for (var compra in favoritosCompras) {
      agrupados.putIfAbsent(compra.categoria, () => []);
      agrupados[compra.categoria]!.add(compra);
    }

    // Agrupar roupas em "Roupas"
    if (favoritosRoupas.isNotEmpty) {
      agrupados.putIfAbsent("Roupas", () => []);
      agrupados["Roupas"]!.addAll(favoritosRoupas);
    }

    setState(() {
      _favoritosPorCategoria = agrupados;
      _carregando = false;
    });
  }
}
