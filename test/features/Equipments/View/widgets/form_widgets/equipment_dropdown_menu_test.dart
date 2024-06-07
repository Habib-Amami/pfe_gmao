import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pfe_gmao/features/Equipments/View/widgets/form_widgets/equipment_dropdown_menu.dart';

void main() {
  testWidgets('EquipmentDropDownMenu renders correctly',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: EquipmentDropDownMenu(
          items: const [
            DropdownMenuItem<Object>(
              value: 'item1',
              child: Text('Item 1'),
            ),
            DropdownMenuItem<Object>(
              value: 'item2',
              child: Text('Item 2'),
            ),
          ],
          value: 'item1',
          onChanged: (value) {},
        ),
      ),
    ));

    // Verify that the dropdown menu is rendered
    expect(find.byType(EquipmentDropDownMenu), findsOneWidget);

    // Verify that the dropdown items are rendered
    expect(find.text('Item 1'), findsOneWidget);

    // Tap the dropdown to open it
    await tester.tap(find.byType(DropdownButtonFormField));
    await tester.pumpAndSettle();

    // Verify that the dropdown is open
    expect(find.byType(ListView), findsOneWidget);
  });
}
