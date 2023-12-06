import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'app.dart';

const _brand = Colors.deepPurple;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print("Native called background task: $task");
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _isUsingDynamicColors = false;

  void loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool darkThemeEnabled = prefs.getBool('darkThemeEnabled') ?? true;
    bool dynamicColorsEnabled = prefs.getBool('dynamicColorsEnabled') ?? false;
    setState(() {
      _themeMode = (darkThemeEnabled) ? ThemeMode.dark : ThemeMode.light;
      _isUsingDynamicColors = dynamicColorsEnabled;
    });
  }

  void toggleTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool darkThemeEnabled = _themeMode == ThemeMode.dark;
    setState(() {
      _themeMode = (darkThemeEnabled) ? ThemeMode.light : ThemeMode.dark;
    });
    prefs.setBool('darkThemeEnabled', !darkThemeEnabled);
  }

  void toggleDynamicColors() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isUsingDynamicColors = (_isUsingDynamicColors) ? false : true;
    });
    prefs.setBool('dynamicColorsEnabled', _isUsingDynamicColors);
  }

  @override
  void initState() {
    loadSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ColorScheme lightColorScheme;
      ColorScheme darkColorScheme;
      if (lightDynamic == null && darkDynamic == null) {
        _isUsingDynamicColors = false;
      }
      if (lightDynamic != null &&
          darkDynamic != null &&
          _isUsingDynamicColors == true) {
        lightColorScheme = lightDynamic.harmonized();
        darkColorScheme = darkDynamic.harmonized();
      } else {
        lightColorScheme = ColorScheme.fromSeed(
          seedColor: _brand,
        );
        darkColorScheme = ColorScheme.fromSeed(
          seedColor: _brand,
          brightness: Brightness.dark,
        );
      }
      return MaterialApp(
        title: 'Refresh',
        theme: ThemeData(
          colorScheme: lightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme,
          useMaterial3: true,
        ),
        themeMode: _themeMode,
        home: App(
          toggleTheme: toggleTheme,
          toggleDynamicColors: toggleDynamicColors,
          themeMode: _themeMode,
          dynamicColorsMode: _isUsingDynamicColors,
        ),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
