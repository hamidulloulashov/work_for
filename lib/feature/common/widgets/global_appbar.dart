import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_for/feature/common/managers/theme_notifier.dart' show ThemeNotifier;

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Widget? leading; 

  const GlobalAppBar({
    super.key,
    required this.title,
    this.actions,
    this.backgroundColor,
    this.leading, 
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return AppBar(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      leading: leading, 
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      actions: [
        if (actions != null) ...actions!,
        IconButton(
          icon: Icon(themeNotifier.themeMode == ThemeMode.light
              ? Icons.dark_mode
              : Icons.light_mode),
          onPressed: () {
            themeNotifier.toggleTheme();
          },
        ),
      ],
    );
  }
}
