import 'package:shared_preferences/shared_preferences.dart';
import 'package:refresh/scrape.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

void checkAndUpdate(String ruleName) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  List<String> currRules = pref.getStringList('currentRules') ?? [];
  int i = 0;
  while (i < currRules.length) {
    String name = currRules[i];
    String url = currRules[i + 1];
    String selector = currRules[i + 2];
    String prevHtml = currRules[i + 3];
    int nUncheckedChanges = int.parse(currRules[i + 5]);
    String newChange = "";
    Logger().i('IN CHECK AND UPDATE FUNCTION');
    if ('$name-worker' == ruleName) {
      String currHtml = await queryRequest(url, selector: selector) ?? '';
      List allDiffs = getAllDiffs(currHtml, prevHtml);
      for (int i = 0; i < allDiffs.length; i++) {
        if (allDiffs[i] != '') {
          newChange = "$newChange${allDiffs[i]}";
        }
      }
      currRules[i + 3] = currHtml;
      currRules[i + 4] = DateFormat().format(DateTime.now());
      currRules[i + 5] = '${nUncheckedChanges + 1}';
      currRules.insert(i + 6 + nUncheckedChanges, newChange);
      pref.setStringList('currentRules', currRules);
    }
  }
}
