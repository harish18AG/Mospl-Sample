import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';

class RecentlyViewedScreen extends StatelessWidget {
  const RecentlyViewedScreen({super.key});
  @override
  Widget build(BuildContext context) => AppScaffold(title: 'Recently Viewed', body: const Center(child: Text('Recently Viewed')));
}
