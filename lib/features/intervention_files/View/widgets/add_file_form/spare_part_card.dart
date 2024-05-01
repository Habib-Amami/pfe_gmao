import 'package:flutter/material.dart';

import '../../../model/data_models/spare_part.dart';

// Define a custom widget called SparePartCard
//this widget will display a card for each SparePart from the database
//this card can be tapped so that the spare part  will be selected
//and added to the selected spare parts list

class SparePartCard extends StatelessWidget {
  final SparePart sparePart; // The sparePart object to be displayed in the card
  final void Function()
      onTap; // Callback function triggered when the card is tapped
  const SparePartCard({
    super.key,
    required this.sparePart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Set elevation based on the selection state of the sparePart
      elevation: sparePart.isSelected == false ? 1 : 6,
      //list tile displaying a spare part tile
      child: ListTile(
        // Display the sparePart name as the title
        title: Text(
          sparePart.name,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        // Display the sparePart description and quantity in a row
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                sparePart.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, left: 16),
              child: Text(
                sparePart.quantity.toString(),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        // Set the selected state of the ListTile based on sparePart selection
        selected: sparePart.isSelected,
        // Assign the onTap callback function to handle tap events
        onTap: onTap,
      ),
    );
  }
}
