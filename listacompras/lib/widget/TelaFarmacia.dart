import 'package:flutter/material.dart';
import 'package:listacompras/validacoes/validadorMercado.dart';

class TelaFarmacia extends StatefulWidget {
  const TelaFarmacia({super.key});

  @override
  State<TelaFarmacia> createState() => _TelaFarmaciaState();
}

class _TelaFarmaciaState extends State<TelaFarmacia> {
  final TextEditingController _itemController = TextEditingController();
  final List<String> _itens = [];
  int? _itemSelecionadoIndex;
  int? _hoverdIndex;

  void _mostrarErro(String mensagem) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Erro'),
      content: Text(mensagem),
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ),
  );
}

 void _adicionarItem() {
  final texto = _itemController.text.trim(); // remove espaços

  if (ValidadorItem.ehValido(texto) && !texto.isEmpty) {
    setState(() {
      _itens.add(texto); // só adiciona se for válido
      _itemController.clear();
    });
  } else {
    _mostrarErro('Item inválido. O nome não pode estar vazio nem conter apenas números.');
  }
}

  void _editarItem() {
  final texto = _itemController.text.trim();

  if (_itemSelecionadoIndex != null && ValidadorItem.ehValido(texto) && !texto.isEmpty) {
    setState(() {
      _itens[_itemSelecionadoIndex!] = texto;
      _itemSelecionadoIndex = null;
      _itemController.clear();
    });
  } else {
    _mostrarErro('Item inválido. O nome não pode estar vazio nem conter apenas números.');
  }
}


  void _excluirItem() {
    if (_itemSelecionadoIndex != null) {
      setState(() {
        _itens.removeAt(_itemSelecionadoIndex!);
        _itemSelecionadoIndex = null;
        _itemController.clear();
      });
    }
  }

  void _selecionarItem(int index) {
    setState(() {
      _itemSelecionadoIndex = index;
      _itemController.text = _itens[index];
    });
  } //essa função é pra preencher o campo de texto, quando o usuário clica no item da lista

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Compras de Medicamentos')),
      body: Row( //pra dividir a tela em duas partes, esquerda e direita
        children: [
          // Lado esquerdo - lista
          Expanded(
            flex: 1,
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                itemCount: _itens.length,
                itemBuilder: (context, index) {
                  final bool isSelected = _itemSelecionadoIndex == index;
                  final bool isHovered = _hoverdIndex == index;

                  return ListTile(
                    tileColor: isSelected ? Colors.green[100] : null,
                    onTap: () => _selecionarItem(index),
                    title: MouseRegion(
                      onEnter: (_) => setState(() => _hoverdIndex = index),
                      onExit: (_) => setState(() => _hoverdIndex = null),
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        _itens[index],
                        style: TextStyle(
                          decoration: isHovered ? TextDecoration.underline : null,
                          color: isHovered ? Colors.deepPurple : Colors.black87,
                          fontWeight: isHovered ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Lado direito - formulario
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Gerenciar Itens:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      labelText: 'Item', //placeholder do campo
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: _adicionarItem,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar  '),
                    style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _editarItem,
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                    style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _excluirItem,
                    icon: const Icon(Icons.delete),
                    label: const Text('Excluir'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
