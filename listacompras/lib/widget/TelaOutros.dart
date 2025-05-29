import 'package:flutter/material.dart';

class TelaOutros extends StatefulWidget {
  const TelaOutros({Key? key}) : super(key: key);

  @override
  State<TelaOutros> createState() => _TelaOutrosState();
}

class _TelaOutrosState extends State<TelaOutros> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _mostrarAlerta);
  }

  void _mostrarAlerta() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('🚧 Funcionalidades em construção 🚧'),
        content: const Text('Novos cards serão adicionados futuramente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outros'),
      ),
      body: const Center(
        child: Text('Aguarde novidades em breve!'),
      ),
    );
  }
}
