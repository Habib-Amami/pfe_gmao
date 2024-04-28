import 'package:flutter/material.dart';

// Custom widget to display a header for a ListView
// used for the tools and spare parts listviews
class ListViewHeader extends StatelessWidget {
  final String firstColumnName; // Title for the first column
  final String secondColumnName; // Title for the second column
  const ListViewHeader({
    super.key,
    required this.firstColumnName,
    required this.secondColumnName,
  });

  @override
  Widget build(BuildContext context) {
    return // Row containing column titles for spare parts list
        Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
        left: 8,
        right: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(firstColumnName),
          Text(secondColumnName),
        ],
      ),
    );
  }
}
