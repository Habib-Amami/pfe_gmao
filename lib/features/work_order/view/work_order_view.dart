import 'package:flutter/material.dart';
import 'package:pfe_gmao/features/interventions/view/widget/intervention_card.dart';

class WorkOrderView extends StatefulWidget {
  const WorkOrderView({super.key});

  @override
  State<WorkOrderView> createState() => _WorkOrderViewState();
}

class _WorkOrderViewState extends State<WorkOrderView> {
  DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        children: [
          GestureDetector(
            onTap: () {},
            child: CalendarCard(
                title: '',
                subtitle: 'Mechanical equipment',
                date: today,
                typeOfCard: 'work order',
                status: 'planned',
                equipmentName: 'SN-201'),
          )
        ],
      ),
    ));
  }
}
