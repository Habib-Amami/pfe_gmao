import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:pfe_gmao/features/Equipments/View/widgets/equipment_tile/equipment_tile_image.dart';
import 'package:pfe_gmao/firebase/cloud_firestore_references.dart';

void main() {
  testWidgets(
    'EquipmentTileImage displays image from network URL',
    (WidgetTester tester) async {
      mockNetworkImagesFor(
        () async {
          // Build the widget tree and pump the EquipmentTileImage widget into it
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: EquipmentTileImage(
                  equipmentImageURL: defaultEquipmentPicture,
                ),
              ),
            ),
          );

          // Verify that the CircleAvatar is found
          expect(find.byType(CircleAvatar), findsOneWidget);

          // Verify that the NetworkImage is used in the CircleAvatar
          final circleAvatar =
              tester.widget<CircleAvatar>(find.byType(CircleAvatar));
          final backgroundImage = circleAvatar.backgroundImage as NetworkImage;
          expect(backgroundImage.url, defaultEquipmentPicture);
        },
      );
    },
  );
}
