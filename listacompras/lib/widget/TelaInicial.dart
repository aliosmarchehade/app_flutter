import 'package:flutter/material.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 148, 206, 168),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Escolha um segmento:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4, //tamanho dos cards
                  crossAxisSpacing: 10, //distancia dos cards
                  mainAxisSpacing: 20,
                  childAspectRatio: 3 / 2,
                  children: [
                    _buildSegmentCard(context, 'Supermercado', Icons.local_grocery_store, '/supermercado'),
                    _buildSegmentCard(context, 'Roupas', Icons.checkroom , '/roupas'),
                    _buildSegmentCard(context, 'Farmácia', Icons.local_pharmacy , '/farmacia'),
                    _buildSegmentCard(context, 'Eletrônicos', Icons.electrical_services , '/eletronicos'),
                    _buildSegmentCard(context, 'Petshop', Icons.pets , '/petshop'),
                    _buildSegmentCard(context, 'Mecânica', Icons.car_repair , '/mecanica'),
                    _buildSegmentCard(context, 'Outros \n(em breve)', Icons.hourglass_bottom , '/outros')
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildSegmentCard(BuildContext context, String title, IconData icon, String url) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Segmento selecionado: $title')),
        );
        Navigator.pushNamed(context, url);
      },
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.deepPurple),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}