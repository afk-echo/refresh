import 'package:flutter/material.dart';
import './pages/home.dart';
import './pages/settings.dart';
import './pages/add.dart';

class App extends StatefulWidget {
  final Function() toggleTheme;
  final Function() toggleDynamicColors;
  final ThemeMode themeMode;
  final bool dynamicColorsMode;
  const App({
    super.key,
    required this.toggleTheme,
    required this.themeMode,
    required this.toggleDynamicColors,
    required this.dynamicColorsMode,
  });

  @override
  State<App> createState() => _HomeState();
}

class _HomeState extends State<App> {
  int currPage = 0;
  List<String> titles = ["Home", "Add Rule", "Settings"];

  @override
  Widget build(BuildContext context) {
    String title = titles[currPage];
    List<Widget> pages = <Widget>[
      const HomePage(),
      const AddPage(),
      SettingsPage(
        toggleTheme: widget.toggleTheme,
        themeMode: widget.themeMode,
        toggleDynamicColors: widget.toggleDynamicColors,
        dynamicColorsMode: widget.dynamicColorsMode,
      )
    ];
    Widget page = pages[currPage];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Text(title),
        ),
      ),
      body: page,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currPage,
        onDestinationSelected: (int index) {
          setState(() {
            currPage = index;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.add_circle_outline),
              selectedIcon: Icon(Icons.add_circle),
              label: 'Add'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: "Settings"),
        ],
      ),
    );
  }
}
