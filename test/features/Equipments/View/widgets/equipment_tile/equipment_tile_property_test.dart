import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pfe_gmao/features/Equipments/View/widgets/equipment_tile/equipment_tile_property.dart';

void main() {
  testWidgets('EquipmentTileProperty displays property name and value', (
    WidgetTester tester,
  ) async {
    const propertyName = 'Name';
    const propertyValue = 'Value';

    //pumping the EquipmentTileProperty widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EquipmentTileProperty(
            propertyName: propertyName,
            propertyValue: propertyValue,
          ),
        ),
      ),
    );

    // Verify if name and value are displayed correctly
    expect(find.text(propertyName), findsOneWidget);
    expect(find.text(propertyValue), findsOneWidget);
  });
}
