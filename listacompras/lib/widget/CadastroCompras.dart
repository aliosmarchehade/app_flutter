import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:listacompras/banco/sqlite/dao/dao_compras.dart';
import 'package:listacompras/models/compra.dart';
import 'package:intl/intl.dart';

class CadastroCompras extends StatefulWidget {
  final Compra? compra;

  const CadastroCompras({super.key, this.compra});

  @override
  State<CadastroCompras> createState() => _CadastroComprasState();
}

class _CadastroComprasState extends State<CadastroCompras> {
  final _formKey = GlobalKey<FormState>();
  final _nomeProdutoController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _precoTotalController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );
  DateTime _dataCompra = DateTime.now();
  final _dao = DAOCompra();

  @override
  void initState() {
    super.initState();
    if (widget.compra != null) {
      _nomeProdutoController.text = widget.compra!.nomeProduto;
      _quantidadeController.text = widget.compra!.quantidade.toString();
      _precoTotalController.updateValue(widget.compra!.precoTotal);
      _dataCompra = widget.compra!.dataCompra;
    }
  }

  @override
  void dispose() {
    _nomeProdutoController.dispose();
    _quantidadeController.dispose();
    _precoTotalController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      final novaCompra = Compra(
        id: widget.compra?.id,
        nomeProduto: _nomeProdutoController.text,
        dataCompra: _dataCompra,
        quantidade: int.parse(_quantidadeController.text),
        precoTotal: _precoTotalController.numberValue,
      );

      try {
        if (widget.compra == null) {
          await _dao.salvar(novaCompra);
        } else {
          await _dao.atualizar(novaCompra);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.compra == null
                  ? 'Compra cadastrada com sucesso!'
                  : 'Compra atualizada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar compra: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? escolhida = await showDatePicker(
      context: context,
      initialDate: _dataCompra,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (escolhida != null) {
      setState(() {
        _dataCompra = escolhida;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          widget.compra == null ? 'Nova Compra' : 'Editar Compra',
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeProdutoController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Produto',
                  hintText: 'Ex: Arroz, Feijão...',
                  labelStyle: TextStyle(color: Colors.amber),
                  hintStyle: TextStyle(color: Colors.amber),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O nome é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantidadeController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade',
                  hintText: 'Número de unidades',
                  labelStyle: TextStyle(color: Colors.amber),
                  hintStyle: TextStyle(color: Colors.amber),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A quantidade é obrigatória';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Informe um número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _precoTotalController,
                decoration: const InputDecoration(
                  labelText: 'Preço Total',
                  hintText: 'Ex: R\$ 10,00',
                  labelStyle: TextStyle(color: Colors.amber),
                  hintStyle: TextStyle(color: Colors.amber),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (_precoTotalController.numberValue <= 0) {
                    return 'Preço deve ser maior que zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Data da Compra: ${formatter.format(_dataCompra)}',
                style: const TextStyle(color: Colors.amber, fontSize: 16),
              ),
              TextButton(
                onPressed: () => _selecionarData(context),
                child: const Text('Selecionar Data'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                onPressed: _salvar,
                child: Text(widget.compra == null ? 'Salvar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
