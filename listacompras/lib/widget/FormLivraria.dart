
import 'package:flutter/material.dart';
import 'package:listacompras/models/genero.dart';
import 'package:listacompras/banco/sqlite/dao/dao_livraria.dart';

class FormLivraria extends StatefulWidget {
  const FormLivraria({super.key});

  @override
  State<FormLivraria> createState() => _FormLivrariaState();
}

class _FormLivrariaState extends State<FormLivraria> {
  final _formKey = GlobalKey<FormState>();
  final _generoController = TextEditingController();

  @override
  void dispose() {
    _generoController.dispose();
    super.dispose();
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final novoGenero = Genero(nomeGenero: _generoController.text.trim());
      final daoLivraria = DAOLivraria.instance;
      try {
        final id = await daoLivraria.salvar(novoGenero); // Salva no banco
        novoGenero.id = id; // Atualiza o ID do objeto
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gênero salvo com sucesso!')),
        );
        Navigator.pushNamed(
          context,
          '/formLivro',
          arguments: novoGenero, // Passa o gênero salvo
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar gênero: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Gênero de Livro'),
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
                controller: _generoController,
                decoration: const InputDecoration(labelText: 'Gênero do Livro'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Informe o gênero' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
