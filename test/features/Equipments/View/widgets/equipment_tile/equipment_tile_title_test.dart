import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pfe_gmao/features/Equipments/View/widgets/equipment_tile/equipment_tile_title.dart';

void main() {
  testWidgets('EquipmentTileTitle displays title with correct style',
      (WidgetTester tester) async {
    // Define the tilte  for testing
    const equipmentTitle = 'Equipment Title';

    //pump the EquipmentTileTitle widget into it
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EquipmentTileTitle(
            tileTitle: equipmentTitle,
          ),
        ),
      ),
    );

    // Verify that the title text is displayed correctly
    final titleFinder = find.text(equipmentTitle);
    expect(titleFinder, findsOneWidget);

    final textWidget = tester.widget<Text>(titleFinder);
    // Verify that the text style is applied correctly
    expect(textWidget.style, isNotNull);
    // Verify that the text weight is applied correctly
    expect(textWidget.style!.fontWeight, FontWeight.w600);
    // Verify that the text color matches the primary color of the theme
    expect(textWidget.style!.color,
        Theme.of(tester.element(titleFinder)).colorScheme.primary);
  });
}
