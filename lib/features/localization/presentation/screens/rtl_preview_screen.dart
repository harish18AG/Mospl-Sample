import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';

class RtlPreviewScreen extends StatelessWidget {
  const RtlPreviewScreen({super.key});
  @override
  Widget build(BuildContext context) => AppScaffold(title: 'Rtl Preview', body: const Center(child: Text('Rtl Preview')));
}
