import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String sectionTile;
  const SectionTitle({
    required this.sectionTile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          sectionTile,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
