import 'package:flutter/material.dart';
import 'package:listacompras/widget/listas/lista_outros.dart';


class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> _abas = const [
    Tab(icon: Icon(Icons.folder_copy_outlined), text: 'Cadastros'),
    Tab(icon: Icon(Icons.list_alt_outlined), text: 'Listas'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _abas.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double spacing = 20.0;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 59, 61, 60),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 45, 126, 85),
        elevation: 0,
        title: const Text(
          'Escolha um segmento',
          
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: _abas,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[400],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCards(context, screenWidth, spacing),
          const ListaProdutosScreen()
        ],
      ),
    );
  }

  Widget _buildCards(BuildContext context, double screenWidth, double spacing) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(screenWidth < 400 ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: spacing,
                    runSpacing: spacing,
                    children: _segments.map((segment) {
                      return _buildSegmentCard(
                        context,
                        segment['title']!,
                        segment['icon'] as IconData,
                        segment['route']!,
                        screenWidth,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
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
    {'title': 'Crud', 'icon': Icons.hourglass_bottom, 'route': '/crud'},
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
      child: SizedBox(
        width: screenWidth < 500 ? 150 : 180,
        height: 150,
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: isSmall ? 32 : 40, color: const Color.fromARGB(255, 76, 19, 175)),
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
      ),
    );
  }
}
