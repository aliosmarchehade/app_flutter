import 'package:flutter/material.dart';
import 'package:listacompras/validacoes/validadorMercado.dart'; // Importe seu validador

class ListaGenerica extends StatefulWidget {
  final String titulo; // Título da AppBar
  final Color appBarColor; // Cor opcional para a AppBar
  final Color listTileSelectedColor; // Cor para o item da lista selecionado
  final Color listTileHoverColor; // Cor do texto do item da lista quando "hovered"

  const ListaGenerica({
    Key? key,
    required this.titulo,
    this.appBarColor = Colors.blue, // Cor padrão para a AppBar
    this.listTileSelectedColor = Colors.green, // Cor padrão para o item selecionado
    this.listTileHoverColor = Colors.deepPurple, // Cor padrão para o texto "hovered"
  }) : super(key: key);

  @override
  State<ListaGenerica> createState() => _ListaGenericaState();
}

class _ListaGenericaState extends State<ListaGenerica> {
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
    final texto = _itemController.text.trim();

    if (ValidadorItem.ehValido(texto) && texto.isNotEmpty) { // Use isNotEmpty em vez de !texto.isEmpty
      setState(() {
        _itens.add(texto);
        _itemController.clear();
      });
    } else {
      _mostrarErro('Item inválido. O nome não pode estar vazio nem conter apenas números.');
    }
  }

  void _editarItem() {
    final texto = _itemController.text.trim();

    if (_itemSelecionadoIndex != null && ValidadorItem.ehValido(texto) && texto.isNotEmpty) {
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
      final String itemParaExcluir = _itens[_itemSelecionadoIndex!];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar Exclusão'),
            content: Text('Tem certeza que deseja excluir "$itemParaExcluir"?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o diálogo
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _itens.removeAt(_itemSelecionadoIndex!);
                    _itemSelecionadoIndex = null;
                    _itemController.clear();
                  });
                  Navigator.of(context).pop(); // Fecha o diálogo após a exclusão
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text('Excluir'),
              ),
            ],
          );
        },
      );
    }
  }

  void _selecionarItem(int index) {
    setState(() {
      _itemSelecionadoIndex = index;
      _itemController.text = _itens[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo), // Usa o título passado como parâmetro
        backgroundColor: widget.appBarColor, // Usa a cor passada ou padrão
      ),
      body: Row(
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
                    tileColor: isSelected ? widget.listTileSelectedColor.withOpacity(0.2) : null, // Usa a cor e opacidade
                    onTap: () => _selecionarItem(index),
                    title: MouseRegion(
                      onEnter: (_) => setState(() => _hoverdIndex = index),
                      onExit: (_) => setState(() => _hoverdIndex = null),
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        _itens[index],
                        style: TextStyle(
                          decoration: isHovered ? TextDecoration.underline : null,
                          color: isHovered ? widget.listTileHoverColor : Colors.black87, // Usa a cor de hover
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
                      labelText: 'Item',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: _adicionarItem,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar  '),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, // Definindo a cor do texto do botão
                    ),
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _editarItem,
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _excluirItem,
                    icon: const Icon(Icons.delete),
                    label: const Text('Excluir'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.black,
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