import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PreviewHtml extends StatelessWidget {
  const PreviewHtml({
    super.key,
    this.htmlChanges =
        "<h3> Truly one of the popups of all time LUMAO LUMAO LUMAO </h3>",
    this.htmlFull =
        "<h3> Truly one of the popups of all time LUMAO LUMAO LUMAO </h3>",
    this.ruleName = "Rule 1",
  });
  final String htmlChanges;
  final String htmlFull;
  final String ruleName;

  @override
  Widget build(context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 8, bottom: 12),
                child: Text(
                  ruleName,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Text(
                  "Rendered changes",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: HtmlWidget(htmlChanges),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Text(
                  "Full page",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: HtmlWidget(htmlFull),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
