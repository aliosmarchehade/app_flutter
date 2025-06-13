import 'package:flutter/material.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 148, 206, 168),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth < 400 ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Escolha um segmento:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 56, 49, 49),
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(100, 0, 0, 0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: _segments.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: screenWidth < 500 ? 220 : 250,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 3 / 2.4, // deixa mais alto
                  ),
                  itemBuilder: (context, index) {
                    final segment = _segments[index];
                    return _buildSegmentCard(
                      context,
                      segment['title']!,
                      segment['icon'] as IconData,
                      segment['route']!,
                      screenWidth,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static final List<Map<String, dynamic>> _segments = [
    {'title': 'Supermercado', 'icon': Icons.local_grocery_store, 'route': '/supermercado'},
    {'title': 'Roupas', 'icon': Icons.checkroom, 'route': '/roupas'},
    {'title': 'Farmácia', 'icon': Icons.local_pharmacy, 'route': '/farmacia'},
    {'title': 'Eletrônicos', 'icon': Icons.electrical_services, 'route': '/eletronicos'},
    {'title': 'Petshop', 'icon': Icons.pets, 'route': '/petshop'},
    {'title': 'Mecânica', 'icon': Icons.car_repair, 'route': '/mecanica'},
    {'title': 'Outros (em breve)', 'icon': Icons.hourglass_bottom, 'route': '/outros'},
  ];

  static Widget _buildSegmentCard(
    BuildContext context,
    String title,
    IconData icon,
    String url,
    double screenWidth,
  ) {
    final bool isSmall = screenWidth < 400;

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: isSmall ? 32 : 40, color: Colors.deepPurple),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: isSmall ? 13 : 15,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
