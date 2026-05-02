import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';

class RecentRecommendationsScreen extends StatelessWidget {
  const RecentRecommendationsScreen({super.key});
  @override
  Widget build(BuildContext context) => AppScaffold(title: 'Recent Recommendations', body: const Center(child: Text('Recent Recommendations')));
}
