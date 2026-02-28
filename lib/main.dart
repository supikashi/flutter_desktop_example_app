import 'package:flutter/material.dart';
import 'tabs/gestures_tab.dart';
import 'tabs/system_api_tab.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DesktopDemo(),
  ));
}

class DesktopDemo extends StatefulWidget {
  const DesktopDemo({super.key});

  @override
  State<DesktopDemo> createState() => _DesktopDemoState();
}

class _DesktopDemoState extends State<DesktopDemo> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() => _selectedIndex = index);
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.touch_app),
                label: Text('Жесты'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_system_daydream),
                label: Text('Система'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedIndex == 0 
                  ? const GesturesTab(key: ValueKey('gestures_tab')) 
                  : const SystemApiTab(key: ValueKey('system_tab')),
            ),
          ),
        ],
      ),
    );
  }
}
