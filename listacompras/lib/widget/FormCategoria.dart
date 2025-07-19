import 'package:flutter/material.dart';
import '../../banco/sqlite/dao/dao_categoria.dart';
import '../../models/categoria.dart';

class FormCategoria extends StatefulWidget {
  const FormCategoria({super.key});

  @override
  State<FormCategoria> createState() => _FormCategoriaState();
}

class _FormCategoriaState extends State<FormCategoria> {
  final _formKey = GlobalKey<FormState>();
  final _dao = CategoriaDAO();

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();

  int? _id;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Categoria) {
      _id = args.id;
      _nomeController.text = args.nome;
      _descricaoController.text = args.descricao ?? '';
    }
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final novaCategoria = Categoria(
        id: _id,
        nome: _nomeController.text.trim(),
        descricao: _descricaoController.text.trim(),
      );
      await _dao.salvar(novaCategoria);
      if (!mounted) return;
      Navigator.of(context).pop(); // volta para a lista
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_id != null ? 'Editar Categoria' : 'Nova Categoria'),
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
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome da Categoria'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição (opcional)'),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
