import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    for (int i = 0; i < currRules.length; i = i + 6) {
      String name = currRules[i];
      String url = currRules[i + 1];
      String selector = currRules[i + 2];
      String changes = currRules[i + 3];
      String prevHtml = currRules[i + 4];
      String lastChecked = currRules[i + 5];
      if (ruleName != name) {
        finalRules.insert(finalRules.length, name);
        finalRules.insert(finalRules.length, url);
        finalRules.insert(finalRules.length, selector);
        finalRules.insert(finalRules.length, changes);
        finalRules.insert(finalRules.length, prevHtml);
        finalRules.insert(finalRules.length, lastChecked);
      }
    }
    pref.setStringList('currentRules', finalRules);
  }

  @override
  Widget build(context) {
    return AlertDialog(
      title: Text("Delete '$ruleName'"),
      content: Text("Are you sure you want to delete this rule?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            deleteRule(ruleName);
            Navigator.pop(context, 'Delete');
          },
          child: Text("Delete"),
        )
      ],
    );
  }
}
