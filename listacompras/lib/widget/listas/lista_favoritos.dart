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
  
  // Agora armazenamos "categoria" e "itens" (que podem ser Compra ou Roupa)
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
        if (item is Compra) {
          return _tileCompra(item);
        } else if (item is Roupa) {
          return _tileRoupa(item);
        } else {
          return const SizedBox();
        }
      }).toList(),
    );
  }

  Widget _tileCompra(Compra compra) {
    return ListTile(
      leading: const Icon(Icons.shopping_cart),
      title: Text(compra.nomeProduto),
      subtitle: Text(
        'Qtd: ${compra.quantidade} • Total: R\$ ${compra.precoTotal.toStringAsFixed(2)}\n'
        'Data: ${DateFormat('dd/MM/yyyy').format(compra.dataCompra)}',
      ),
      trailing: IconButton(
        icon: Icon(
          compra.favorito ? Icons.star : Icons.star_border,
          color: compra.favorito ? Colors.amber : Colors.grey,
        ),
        onPressed: () async {
          final atualizado = Compra(
            id: compra.id,
            nomeProduto: compra.nomeProduto,
            quantidade: compra.quantidade,
            precoTotal: compra.precoTotal,
            dataCompra: compra.dataCompra,
            categoria: compra.categoria,
            favorito: !compra.favorito,
          );
          await _daoCompra.salvar(atualizado);
          _carregar();
        },
      ),
    );
  }

  Widget _tileRoupa(Roupa roupa) {
    return ListTile(
      leading: const Icon(Icons.checkroom),
      title: Text(roupa.nomeRoupa),
      subtitle: Text(
        'Marca: ${roupa.marca ?? 'N/A'} • Tamanho: ${roupa.tamanho}\n'
        'Preço: R\$ ${roupa.preco?.toStringAsFixed(2)}',
      ),
      trailing: IconButton(
        icon: Icon(
          roupa.favorito ? Icons.star : Icons.star_border,
          color: roupa.favorito ? Colors.amber : Colors.grey,
        ),
        onPressed: () async {
          final atualizado = Roupa(
            id: roupa.id,
            nomeRoupa: roupa.nomeRoupa,
            tamanho: roupa.tamanho,
            marca: roupa.marca,
            preco: roupa.preco,
            favorito: !roupa.favorito,
          );
          await _daoRoupa.salvar(atualizado);
          _carregar();
        },
      ),
    );
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);

    final compras = await _daoCompra.consultarTodos();
    final roupas = await _daoRoupa.consultarTodos();

    final favoritosCompras = compras.where((c) => c.favorito).toList();
    final favoritosRoupas = roupas.where((r) => r.favorito).toList();

    final Map<String, List<dynamic>> agrupados = {};

    // Adiciona compras por categoria
    for (var compra in favoritosCompras) {
      agrupados.putIfAbsent(compra.categoria, () => []);
      agrupados[compra.categoria]!.add(compra);
    }

    // Adiciona roupas na categoria "Roupas"
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
