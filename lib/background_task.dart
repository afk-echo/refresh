import 'package:shared_preferences/shared_preferences.dart';
import 'package:refresh/scrape.dart';
import 'package:intl/intl.dart';

void checkAndUpdate(String ruleName) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  List<String> currRules = pref.getStringList('currentRules') ?? [];
  for (int i = 0; i < currRules.length; i = i + 6) {
    String name = currRules[i];
    String url = currRules[i + 1];
    String selector = currRules[i + 2];
    String prevHtml = currRules[i + 4];
    if ('$name-worker' == ruleName) {
      String currHtml = await queryRequest(url, selector: selector) ?? '';
      List allDiffs = getAllDiffs(currHtml, prevHtml);
      String currChanges = '';
      for (int i = 0; i < allDiffs.length; i++) {
        if (allDiffs[i] != '') {
          currChanges = "$currChanges<br>${allDiffs[i]}";
        }
      }
      currRules[i + 3] = currChanges;
      currRules[i + 4] = currHtml;
      currRules[i + 5] = DateFormat().format(DateTime.now());
      pref.setStringList('currentRules', currRules);
    }
  }
}
