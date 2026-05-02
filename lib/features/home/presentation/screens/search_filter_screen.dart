import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';

class SearchFilterScreen extends StatelessWidget {
  const SearchFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Search & Filters',
      body: ListView(padding: const EdgeInsets.all(16), children: const [
        SearchBar(hintText: 'Search leather products...'),
        SizedBox(height: 12),
        Text('Price Range'),
        RangeSlider(values: RangeValues(20, 200), min: 0, max: 500, onChanged: null),
      ]),
    );
  }
}
