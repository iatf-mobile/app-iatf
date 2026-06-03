import 'package:flutter/material.dart';

import '../../home/home_screen.dart';
import '../../protocols/protocols_screen.dart';
import '../../fazendas/fazendas_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    // FichaScreen(),
    ProtocolsScreen(),
    FazendasScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  // Chamado ao deslizar o dedo
  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      // NavigationBar sincronizada com o PageView
      bottomNavigationBar: NavigationBar(
        backgroundColor: cs.surfaceContainerLow,
        selectedIndex: _currentIndex,
        onDestinationSelected: _onNavTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment_rounded),
            label: 'Ficha',
          ),
          NavigationDestination(
            icon: Icon(Icons.science_outlined),
            selectedIcon: Icon(Icons.science_rounded),
            label: 'Protocolos',
          ),
          NavigationDestination(
            icon: Icon(Icons.landscape_outlined),
            selectedIcon: Icon(Icons.landscape_rounded),
            label: 'Fazendas',
          ),
        ],
      ),

      // Permite deslizar entre as telas
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _screens,
      ),
    );
  }
}