import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.brown.shade100,
      highlightColor: Colors.white,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (_, __) => const ListTile(title: SizedBox(height: 20, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white)))),
      ),
    );
  }
}
