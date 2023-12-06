import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:diff_match_patch/diff_match_patch.dart';

Future<String?> queryRequest(String url, {String selector = 'body'}) async {
  if (url == "") {
    return '<p>Enter a valid URL for obtaining a preview.</p>';
  }
  try {
    var response = await http.Client().get(Uri.parse(url));
    if (response.statusCode == 200) {
      var document = parse(response.body);
      var quotes = document.querySelector(selector);
      return quotes!.innerHtml;
    } else {
      return '<h2>An Error Occured(Response Status Code: <strong>${response.statusCode}</strong>)</h2>';
    }
  } catch (err) {
    return '!!!${err.toString()}';
  }
}

List getAllDiffs(String first, String last) {
  if (first == last) {
    return [];
  }
  List allDiffs = [];
  List diffs = diff(first, last);
  for (int i = 0; i < diffs.length; i++) {
    if (diffs[i].operation == 1) {
      allDiffs.insert(allDiffs.length, diffs[i].text);
    }
  }
  return allDiffs;
}

String? highlightDiffs(String curr, List<String> changes) {
  if (changes.isEmpty) {
    return null;
  }
  String highlighted = curr;
  for (int i = 0; i < changes.length; i++) {
    highlighted = highlighted.replaceAll(changes[i],
        "<div style='background-color:yellow'> ${changes[i]} </div>");
  }
  return highlighted;
}

void main() async {
  print(highlightDiffs('hehe boy', ['then work', 'your palet knife']));
}
