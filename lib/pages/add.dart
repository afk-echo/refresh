import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:refresh/scrape.dart';
import 'package:workmanager/workmanager.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  // ignore: prefer_typing_uninitialized_variables
  var _futureInstance;
  static const double smallTextSize = 14;
  bool _newRuleName = true, _validURL = true, _validSelector = true;
  String _name = "", _url = "", _selector = "body";
  int _frequency = 15;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController selectorController = TextEditingController();

  void addRule(bool preview) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> currRules = pref.getStringList('currentRules') ?? [];
    _frequency = pref.getInt('frequency') ?? 15;
    String firstHtml;
    firstHtml = await queryRequest(_url, selector: _selector) ??
        '<h3>HTML could not be fetched.</h3>';
    if (_name.isEmpty || currRules.contains(_name)) {
      setState(() {
        _newRuleName = false;
      });
      return;
    }
    if (firstHtml.startsWith('!!!')) {
      firstHtml = firstHtml.replaceAll('!!!', '');
      if (firstHtml.startsWith('Invalid argument')) {
        setState(() {
          _validURL = false;
        });
      } else if (firstHtml.startsWith('FormatException')) {
        setState(() {
          _validSelector = false;
        });
      }
      return;
    }
    setState(() {
      _newRuleName = true;
      _validURL = true;
      _validSelector = true;
    });
    if (preview) {
      return;
    }
    if (_name != "" && _url != "" && _selector != "") {
      currRules = [
        currRules,
        [
          _name,
          _url,
          _selector,
          firstHtml,
          DateFormat().format(DateTime.now()),
          '0',
        ]
      ].expand((element) => element).toList();
      print(currRules);
      pref.setStringList('currentRules', currRules);
    }
  }

  @override
  void initState() {
    super.initState();
    _futureInstance = (String url, {String selector = 'body'}) =>
        queryRequest(url, selector: selector);
  }

  @override
  void dispose() {
    urlController.dispose();
    nameController.dispose();
    selectorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(shrinkWrap: false, children: [
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Text("Rule Parameters",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: smallTextSize)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Assign a name to this rule.',
              border: const OutlineInputBorder(),
              errorText:
                  (_newRuleName) ? null : "Name must unique and non-blank",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: TextField(
            controller: urlController,
            decoration: InputDecoration(
              labelText: 'URL',
              hintText: 'Link to website for checking periodically.',
              border: const OutlineInputBorder(),
              errorText: (_validURL) ? null : 'Enter a valid URL',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: TextField(
            controller: selectorController,
            decoration: InputDecoration(
              labelText: 'Selector',
              hintText: '(optional) Selector to check a single element.',
              border: const OutlineInputBorder(),
              errorText: _validSelector ? null : 'Enter a valid selector',
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 7, bottom: 14),
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _name = nameController.text;
                      _url = urlController.text;
                      _selector = selectorController.text;
                    });
                    addRule(true);
                  },
                  child: const Text("Preview"),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 7, bottom: 14),
                child: FilledButton(
                  onPressed: () async {
                    setState(() {
                      _name = nameController.text;
                      _url = urlController.text;
                      _selector = selectorController.text;
                    });
                    addRule(false);
                    Workmanager().registerPeriodicTask(
                        '$_name-checker', '$_name-worker',
                        frequency: Duration(minutes: _frequency),
                        inputData: <String, dynamic>{
                          'string': _name,
                        });
                  },
                  child: const Text("Add"),
                ),
              ),
            ),
          ],
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 14),
          child: Text("Element Preview",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: smallTextSize)),
        ),
        FutureBuilder(
          future: _futureInstance(_url, selector: _selector),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: Center(child: CircularProgressIndicator())),
                ],
              );
            } else if (snapshot.hasData) {
              String data = snapshot.data.toString();
              if (!data.startsWith('!!!')) {
                return HtmlWidget(snapshot.data.toString());
              } else {
                return const HtmlWidget('');
              }
            }
            return const HtmlWidget('''
          <h3>Error</h3>
          <p>
An unknown error occured. Please use a valid URL and Selector.
          </p>
          ''');
          },
        ),
      ]),
    );
  }
}
