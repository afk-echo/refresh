import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class DeletionPopout extends StatelessWidget {
  const DeletionPopout({
    super.key,
    required this.ruleName,
  });
  final String ruleName;

  void deleteRule(ruleName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> currRules = pref.getStringList('currentRules') ?? [];
    List<String> finalRules = [];
    int i = 0;
    Workmanager().cancelByUniqueName("$ruleName-checker");
    while (i < currRules.length) {
      String name = currRules[i];
      String url = currRules[i + 1];
      String selector = currRules[i + 2];
      String prevHtml = currRules[i + 3];
      String lastChecked = currRules[i + 4];
      String nUncheckedChanges = currRules[i + 5];
      if (ruleName != name) {
        finalRules = [
          finalRules,
          [name, url, selector, prevHtml, lastChecked, nUncheckedChanges]
        ].expand((element) => element).toList().cast<String>();

        print("$i, ${i + 6}");
        finalRules = [
          finalRules,
          finalRules.sublist(i + 6, i + 6 + int.parse(nUncheckedChanges))
        ].expand((element) => element).toList().cast<String>();
      }
      i = i + 6 + int.parse(nUncheckedChanges);
    }
    pref.setStringList('currentRules', finalRules);
  }

  @override
  Widget build(context) {
    return AlertDialog(
      title: Text("Delete '$ruleName'"),
      content: const Text("Are you sure you want to delete this rule?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            deleteRule(ruleName);
            Navigator.pop(context, 'Delete');
          },
          child: const Text("Delete"),
        )
      ],
    );
  }
}
