// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:refresh/custom_card.dart';
import 'package:refresh/custom_card_item.dart';
import 'package:refresh/preview_html.dart';
import 'package:refresh/deletion_popout.dart';

class RuleInfoCard extends StatelessWidget {
  const RuleInfoCard({
    super.key,
    required this.title,
    this.subtitle = "No changes detected.",
    this.headerIcon = const Icon(
      Icons.numbers_rounded,
      size: 32,
    ),
    this.changesIcon = const Icon(
      Icons.check_circle,
      color: Colors.green,
    ),
    this.url = "<insert url variable with url: property>",
    this.selector = "<insert selector with selector: property>",
    this.changes = const ["<insert changes with changes: property>"],
    this.prevHtml = "<h3>insert prev html</h3>",
    this.lastChecked = "<insert lastChecked with lastChecked: property>",
  });
  final Icon headerIcon;
  final Icon changesIcon;
  final String title, subtitle, url, selector, prevHtml, lastChecked;
  final List<String> changes;

  @override
  Widget build(context) {
    return ExpandablePanel(
      theme: ExpandableThemeData(
        hasIcon: false,
        iconColor: Theme.of(context).iconTheme.color,
      ),
      header: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 14, 0, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 14, 8),
                    child: headerIcon,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    size: 24,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => PreviewHtml(
                        ruleName: title,
                        htmlChanges: changes.isEmpty
                            ? '<p>No changes since last check.</p>'
                            : changes[0],
                        htmlFull: prevHtml,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 24,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => DeletionPopout(ruleName: title),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 14),
                  child: Icon(Icons.arrow_drop_down_sharp),
                )
              ],
            ),
          ],
        ),
      ),
      collapsed: const SizedBox(),
      expanded: CustomCard(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            CustomCardItem(
              title: Text('URL'),
              subtitle: Text(url),
              icon: Icon(Icons.link),
            ),
            CustomCardItem(
              title: Text('Selector'),
              subtitle: Text(selector),
              icon: Icon(Icons.code),
            ),
            CustomCardItem(
              title: Text('Changes'),
              subtitle: Text(changes.isEmpty
                  ? 'No changes detected.'
                  : '${changes.length} change(s) detected!'),
              icon: changes.isEmpty
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.update,
                      color: Colors.yellowAccent,
                    ),
            ),
            CustomCardItem(
              title: Text('Last Checked'),
              subtitle: Text(lastChecked),
              icon: Icon(Icons.timer),
            ),
          ],
        ),
      ),
    );
  }
}
