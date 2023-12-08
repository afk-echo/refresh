import 'package:flutter/material.dart';
import 'package:refresh/rule_info_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _currWidgets = <Widget>[];
  static double smallFontSize = 14;

  void loadRules() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> currRules = pref.getStringList('currentRules') ?? [];
    setState(() {
      _currWidgets.clear();
    });
    int i = 0;
    while (i < currRules.length) {
      String name = currRules[i];
      String url = currRules[i + 1];
      String selector = currRules[i + 2];
      String prevHtml = currRules[i + 3];
      String lastChecked = currRules[i + 4];
      String nUncheckedChanges = currRules[i + 5];
      List<String> changes =
          currRules.sublist(i + 6, i + 6 + int.parse(nUncheckedChanges));
      Widget currRule = RuleInfoCard(
        title: name,
        subtitle: (nUncheckedChanges == '0')
            ? 'No changes detected.'
            : 'Changes detected!',
        url: url,
        selector: selector,
        changes: changes,
        prevHtml: prevHtml,
        lastChecked: lastChecked,
      );
      i = i + 6 + int.parse(nUncheckedChanges);
      setState(() {
        _currWidgets.insert(_currWidgets.length, currRule);
      });
    }
    if (_currWidgets.isEmpty) {
      Widget centerElement = Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            "No rules detected. Try adding a rule to get started.",
            style: TextStyle(fontSize: smallFontSize),
          ),
        ),
      );
      setState(() {
        _currWidgets.insert(0, centerElement);
      });
    }
  }

  @override
  void initState() {
    loadRules();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _currWidgets.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text("Current Rules",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: smallFontSize)),
          );
        } else {
          loadRules();
          return _currWidgets[index - 1];
        }
      },
    );
  }
}
