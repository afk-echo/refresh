import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final Function() toggleTheme;
  final Function() toggleDynamicColors;
  final ThemeMode themeMode;
  final bool dynamicColorsMode;
  const SettingsPage({
    super.key,
    required this.toggleTheme,
    required this.themeMode,
    required this.toggleDynamicColors,
    required this.dynamicColorsMode,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const double _paddingL = 16.0;
  static const double smallFontSize = 14.0;
  final TextEditingController frequencyController = TextEditingController();

  void updateFrequency(int seconds) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('frequency', seconds);
  }

  void setFrequencyOnLoad(TextEditingController controller) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int freq = pref.getInt('frequency') ?? 15;
    controller.text = freq.toString();
  }

  @override
  void initState() {
    setFrequencyOnLoad(frequencyController);
    super.initState();
  }

  @override
  void dispose() {
    frequencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool darkThemeToggleValue = widget.themeMode == ThemeMode.dark;
    bool dynamicColorsToggleValue = widget.dynamicColorsMode;
    return Padding(
      padding: const EdgeInsets.fromLTRB(_paddingL, 14, 14, 16),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Text(
              "Appearance",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: smallFontSize),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 14.0, 14.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Toggle Dark Mode",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Switches application theme from dark to light and vice versa.",
                        style: TextStyle(fontSize: smallFontSize),
                      ),
                    ],
                  ),
                ),
                Switch(
                    value: darkThemeToggleValue,
                    onChanged: (bool value) {
                      setState(() {
                        darkThemeToggleValue = value;
                        widget.toggleTheme();
                      });
                    }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 14.0, 14.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Material You Colors",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Toggles application color scheme using Material You colors. Setting turns on only for Android versions 12.0+",
                          style: TextStyle(fontSize: smallFontSize),
                        ),
                      ],
                    ),
                  ),
                ),
                Switch(
                    value: dynamicColorsToggleValue,
                    onChanged: (bool value) {
                      setState(() {
                        dynamicColorsToggleValue = value;
                        widget.toggleDynamicColors();
                      });
                    }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28, bottom: 8),
            child: Text(
              "Scraping",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: smallFontSize),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: frequencyController,
              onChanged: (value) async {
                if (value.isEmpty || int.parse(value) < 15) {
                  updateFrequency(15);
                } else {
                  updateFrequency(int.parse(value));
                }
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                  labelText: 'Frequency (in minutes)',
                  border: OutlineInputBorder(),
                  hintText: '(minimum frequency: 15 minutes)'),
            ),
          ),
        ],
      ),
    );
  }
}
