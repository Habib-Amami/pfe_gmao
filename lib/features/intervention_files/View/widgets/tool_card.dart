import 'package:flutter/material.dart';

import '../../model/data_models/tool.dart';

// Define a custom widget called ToolCard
//this widget will display a card for each Tool from the database
//this card can be tapped so that the tool will be selected
//and added to the selected tools list

class ToolCard extends StatelessWidget {
  final Tool tool; // The tool object to be displayed in the card
  final void Function()
      onTap; // Callback function triggered when the card is tapped
  const ToolCard({
    super.key,
    required this.tool,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Set elevation based on the selection state of the tool
      elevation: tool.isSelected == false ? 1 : 6,
      //list tile displaying a spare part tile
      child: ListTile(
        // Display the tool name as the title
        title: Text(
          tool.name,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        // Display the tool description and quantity in a row
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                tool.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, left: 16),
              child: Text(
                tool.quantity.toString(),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        // Set the selected state of the ListTile based on tool selection
        selected: tool.isSelected,
        // Assign the onTap callback function to handle tap events
        onTap: onTap,
      ),
    );
  }
}
