import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pfe_gmao/features/Equipments/View/widgets/equipment_tile/equipment_tile_status.dart';

void main() {
  testWidgets(
    'EquipmentTileStatus displays correct label, icon and color for active status',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EquipmentTileStatus(equipmentStatus: 'active'),
          ),
        ),
      );

      // Verify that the status label is displayed
      expect(find.text('Status:'), findsOneWidget);

      // Verify that the correct icon is displayed
      final iconFinder = find.byIcon(Ionicons.checkmark_sharp);
      expect(iconFinder, findsOneWidget);

      //Verify that the correct icon container is displayed
      final containerWidget = tester.widget<Container>(
        find.ancestor(
          of: iconFinder,
          matching: find.byType(Container),
        ),
      );
      expect(
        containerWidget.decoration,
        const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
      );
    },
  );

  testWidgets(
    'EquipmentTileStatus displays correct label, icon and color for shutdown status',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EquipmentTileStatus(equipmentStatus: 'shutdown'),
          ),
        ),
      );

      // Verify that the status label is displayed
      expect(find.text('Status:'), findsOneWidget);

      // Verify that the correct icon and color are displayed
      final iconFinder = find.byIcon(Icons.power_off_outlined);
      expect(iconFinder, findsOneWidget);

      //Verify that the correct icon container is displayed
      final containerWidget = tester.widget<Container>(
        find.ancestor(
          of: iconFinder,
          matching: find.byType(Container),
        ),
      );
      expect(
        containerWidget.decoration,
        const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
      );
    },
  );

  testWidgets(
    'EquipmentTileStatus displays correct label, icon and color for standby status',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EquipmentTileStatus(equipmentStatus: 'standby'),
          ),
        ),
      );

      // Verify that the status label is displayed
      expect(find.text('Status:'), findsOneWidget);

      // Verify that the correct icon and color are displayed
      final iconFinder = find.byIcon(Ionicons.pause_circle_outline);
      expect(iconFinder, findsOneWidget);

      //Verify that the correct icon container is displayed
      final containerWidget = tester.widget<Container>(
        find.ancestor(
          of: iconFinder,
          matching: find.byType(Container),
        ),
      );
      expect(
        containerWidget.decoration,
        const BoxDecoration(shape: BoxShape.circle, color: Colors.yellow),
      );
    },
  );

  testWidgets(
    'EquipmentTileStatus displays correct label, icon and color for unknown status',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EquipmentTileStatus(equipmentStatus: 'unknown'),
          ),
        ),
      );

      // Verify that the status label is displayed
      expect(find.text('Status:'), findsOneWidget);

      // Verify that the correct icon and color are displayed
      final iconFinder = find.byIcon(Icons.error_outline);
      expect(iconFinder, findsOneWidget);

      //Verify that the correct icon container is displayed
      final containerWidget = tester.widget<Container>(
        find.ancestor(
          of: iconFinder,
          matching: find.byType(Container),
        ),
      );
      expect(
        containerWidget.decoration,
        const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
      );
    },
  );
}
