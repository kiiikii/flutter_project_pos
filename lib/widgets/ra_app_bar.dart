import 'package:flutter/material.dart';

// Re-usable minimalist AppBar
class RAAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const RAAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
