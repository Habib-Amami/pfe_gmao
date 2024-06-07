import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:pfe_gmao/features/Equipments/View/widgets/equipment_tile/equipment_tile.dart';
import 'package:pfe_gmao/features/Equipments/model/data_models/equipment.dart';
import 'package:pfe_gmao/firebase/cloud_firestore_references.dart';

void main() {
  // Equipment object for testing
  late Equipment testEquipment;

  setUp(
    () {
      testEquipment = Equipment(
        id: '1',
        TagName: 'Sample Equipment',
        Photo: defaultEquipmentPicture,
        Status: 'active',
        Description: 'Sample Description',
        CreatedOn: Timestamp.now(),
        UpdatedOn: Timestamp.now(),
        Priority: 'High',
        Discipline: 'Mechanical',
        Workshop: 'Main Workshop',
        Area: 'Area 1',
        Latitude: '0.0',
        Longitude: '0.0',
        contract: "",
        userManual: "",
      );
    },
  );

  testWidgets('EquipmentTile displays equipment properties correctly',
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EquipmentTile(equipment: testEquipment),
          ),
        ),
      );

      // Verify that the expansion tile is initially collapsed
      expect(find.text('Description:'), findsNothing);

      // Tap the expansion tile to expand it
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      // Verify that the Description propertie is displayed correctly after expansion
      expect(find.text('Description:'), findsOneWidget);
      expect(find.text('Sample Description'), findsOneWidget);
      // Verify that the Created at propertie is displayed correctly after expansion
      expect(find.text('Created at:'), findsOneWidget);
      expect(
          find.text(DateFormat('dd-MM-yyyy')
              .format(testEquipment.CreatedOn.toDate())),
          findsOneWidget);
      // Verify that the Priority propertie is displayed correctly after expansion
      expect(find.text('Priority:'), findsOneWidget);
      expect(find.text('High'), findsOneWidget);
      // Verify that the Discipline propertie is displayed correctly after expansion
      expect(find.text('Discipline:'), findsOneWidget);
      expect(find.text('Mechanical'), findsOneWidget);
      // Verify that the Workshop propertie is displayed correctly after expansion
      expect(find.text('Workshop:'), findsOneWidget);
      expect(find.text('Main Workshop'), findsOneWidget);
      // Verify that the Area propertie is displayed correctly after expansion
      expect(find.text('Area:'), findsOneWidget);
      expect(find.text('Area 1'), findsOneWidget);
      // Verify that the text buttons are displayed correctly
      expect(find.byType(OpenContainer), findsExactly(2));
    });
  });
}
