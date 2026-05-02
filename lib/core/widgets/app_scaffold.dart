import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/app_state.dart';

class AppScaffold extends ConsumerWidget {
  const AppScaffold({super.key, required this.title, required this.body, this.showBottomNav = true});
  final String title;
  final Widget body;
  final bool showBottomNav;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.watch(bottomNavProvider);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: Drawer(
        child: ListView(children: const [DrawerHeader(child: Text('MOSPL Menu')), ListTile(title: Text('Orders')), ListTile(title: Text('Support'))]),
      ),
      body: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: body),
      bottomNavigationBar: showBottomNav
          ? NavigationBar(
              selectedIndex: nav,
              onDestinationSelected: (v) => ref.read(bottomNavProvider.notifier).state = v,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), label: 'Shop'),
                NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
            )
          : null,
    );
  }
}
