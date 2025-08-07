
import 'package:flutter/material.dart';
import 'package:listacompras/models/genero.dart';
import 'package:listacompras/models/livro.dart';
import 'package:listacompras/banco/sqlite/dao/dao_livraria.dart';
import 'package:listacompras/banco/sqlite/dao/dao_livros.dart';

class FormLivro extends StatefulWidget {
  const FormLivro({super.key});

  @override
  State<FormLivro> createState() => _FormLivroState();
}

class _FormLivroState extends State<FormLivro> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _precoController = TextEditingController();
  int? _generoSelecionadoId;

  late Future<List<Genero>> _generosFuture;

  @override
  void initState() {
    super.initState();
    _generosFuture = DAOLivraria.instance.listar();
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final preco = double.tryParse(_precoController.text);
      if (preco == null || preco <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preço inválido')),
        );
        return;
      }
      final livro = Livro(
        titulo: _tituloController.text,
        autor: _autorController.text.isEmpty ? null : _autorController.text,
        preco: preco,
        generoId: _generoSelecionadoId,
      );
      try {
        await DAOLivro.instance.salvar(livro); // Salva o livro no banco
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Livro salvo com sucesso!')),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar livro: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Livro'),
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
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título do Livro'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o título' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _autorController,
                decoration:
                    const InputDecoration(labelText: 'Autor (opcional)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _precoController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Preço'),
                validator: (value) {
                  final valor = double.tryParse(value ?? '');
                  return (valor == null || valor <= 0)
                      ? 'Preço inválido'
                      : null;
                },
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<Genero>>(
                future: _generosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Erro ao carregar os gêneros: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Nenhum gênero cadastrado.');
                  } else {
                    final generos = snapshot.data!;
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: 'Gênero'),
                      value: _generoSelecionadoId,
                      items: generos.map((g) {
                        return DropdownMenuItem(
                          value: g.id,
                          child: Text(g.nomeGenero),
                        );
                      }).toList(),
                      onChanged: (id) {
                        setState(() {
                          _generoSelecionadoId = id;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Selecione o gênero' : null,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
