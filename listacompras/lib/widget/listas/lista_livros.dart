import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../banco/sqlite/dao/dao_livros.dart';
import '../../models/livro.dart';
import '../../../configuracao/rotas.dart'; // ajuste se necessário

class ListaLivrosScreen extends StatefulWidget {
  const ListaLivrosScreen({super.key});

  @override
  State<ListaLivrosScreen> createState() => _ListaLivrosScreenState();
}

class _ListaLivrosScreenState extends State<ListaLivrosScreen> {
  final DAOLivro _dao = DAOLivro.instance;
  List<Livro> _livros = [];
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
        title: const Text('Livros Cadastrados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregar,
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _livros.isEmpty
              ? const Center(child: Text('Nenhum livro cadastrado'))
              : ListView.builder(
                  itemCount: _livros.length,
                  itemBuilder: (context, index) => _itemLista(_livros[index]),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            Rotas.livro,
          ).then((_) => _carregar());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _itemLista(Livro livro) {
    return ListTile(
      leading: const Icon(Icons.menu_book),
      title: Text(livro.titulo),
      subtitle: Text(
        'Autor: ${livro.autor ?? "N/A"} • Preço: R\$ ${livro.preco.toStringAsFixed(2)}',
      ),
      trailing: Wrap(
        spacing: 12,
        children: [
          IconButton(
            icon: Icon(
              livro.favorito ? Icons.star : Icons.star_border,
              color: livro.favorito ? Colors.amber : Colors.grey,
            ),
            onPressed: () async {
              final novoLivro = Livro(
                id: livro.id,
                titulo: livro.titulo,
                autor: livro.autor,
                preco: livro.preco,
                generoId: livro.generoId,
                favorito: !livro.favorito,
              );
              await _dao.salvar(novoLivro);

              setState(() {
                final index = _livros.indexWhere((l) => l.id == livro.id);
                if (index != -1) {
                  _livros[index] = novoLivro;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _excluir(livro),
          ),
        ],
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          Rotas.livro,
          arguments: livro,
        ).then((_) => _carregar());
      },
    );
  }

  Future<void> _carregar() async {
    setState(() => _carregando = true);
    _livros = await _dao.listar();
    setState(() => _carregando = false);
  }

  Future<void> _excluir(Livro livro) async {
    await _dao.excluir(livro.id!);
    _carregar();
  }
}
