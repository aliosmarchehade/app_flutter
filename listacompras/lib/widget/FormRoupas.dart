import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listacompras/banco/sqlite/dao/dao_roupa.dart';
import 'package:listacompras/models/roupa.dart';

class FormRoupas extends StatefulWidget {
  const FormRoupas({super.key});

  @override
  State<FormRoupas> createState() => _FormRoupaState();
}

class _FormRoupaState extends State<FormRoupas> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _marcaController = TextEditingController();
  final _precoController = TextEditingController();
  final _dataController = TextEditingController();
  String? _tamanhoSelecionado;

  DateTime _dataCompra = DateTime.now();
  int? _idRoupa;

  final List<String> tamanhos = ['PP', 'P', 'M', 'G', 'GG'];

  @override
  void initState() {
    super.initState();
    _dataController.text = DateFormat('dd/MM/yyyy').format(_dataCompra);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Roupa) {
      _idRoupa = args.id;
      _nomeController.text = args.nomeRoupa;
      _marcaController.text = args.marca ?? '';
      _tamanhoSelecionado = args.tamanho;
      _precoController.text = args.preco?.toStringAsFixed(2) ?? '';
      // você pode adicionar _dataCompra se salvar a data no modelo
    }
  }

  Future<void> _selecionarData() async {
    final dataEscolhida = await showDatePicker(
      context: context,
      initialDate: _dataCompra,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (dataEscolhida != null) {
      setState(() {
        _dataCompra = dataEscolhida;
        _dataController.text = DateFormat('dd/MM/yyyy').format(_dataCompra);
      });
    }
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final roupa = Roupa(
        id: _idRoupa,
        nomeRoupa: _nomeController.text,
        tamanho: _tamanhoSelecionado!,
        marca: _marcaController.text,
        preco: double.parse(_precoController.text),
        // dataCompra não está sendo salva no banco no seu modelo atual
      );

      if (_idRoupa != null) {
        await DAORoupa().atualizar(roupa);
      } else {
        await DAORoupa().salvar(roupa);
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _marcaController.dispose();
    _precoController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_idRoupa != null ? 'Editar Roupa' : 'Nova Roupa'),
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
                decoration: const InputDecoration(labelText: 'Nome da Roupa'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tamanho'),
                value: _tamanhoSelecionado,
                items: tamanhos.map((t) {
                  return DropdownMenuItem(
                    value: t,
                    child: Text(t),
                  );
                }).toList(),
                onChanged: (t) {
                  setState(() {
                    _tamanhoSelecionado = t;
                  });
                },
                validator: (value) =>
                    value == null ? 'Selecione o tamanho' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _precoController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Preço'),
                validator: (value) {
                  final valor = double.tryParse(value ?? '');
                  return (valor == null || valor <= 0)
                      ? 'Preço inválido'
                      : null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dataController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Data da Compra',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _selecionarData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
