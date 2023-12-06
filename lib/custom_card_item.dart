import 'package:flutter/material.dart';

class CustomCardItem extends StatelessWidget {
  const CustomCardItem({
    Key? key,
    this.icon,
    required this.title,
    this.subtitle,
  }) : super(key: key);
  final Widget? icon;
  final Widget title;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
        width: 48.0,
        child: Center(
          child: icon,
        ),
      ),
      title: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
        child: title,
      ),
      subtitle: subtitle != null
          ? DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
              child: subtitle!,
            )
          : null,
    );
  }
}
