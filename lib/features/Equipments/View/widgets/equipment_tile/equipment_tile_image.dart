import 'package:flutter/material.dart';

// Widget for displaying the image of equipment in a circle avatar
class EquipmentTileImage extends StatelessWidget {
  final String equipmentImageURL;
  const EquipmentTileImage({
    required this.equipmentImageURL,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // CircleAvatar widget for displaying the image
    return CircleAvatar(
      radius: 30,
      backgroundImage: NetworkImage(
        equipmentImageURL, // Loading image from network using URL
      ),
    );
  }
}
