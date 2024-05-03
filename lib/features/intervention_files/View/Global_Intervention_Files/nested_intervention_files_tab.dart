import 'package:flutter/material.dart';

import '../../../Equipments/model/data_models/discipline_list.dart';
import 'intervention_fileq_stream.dart';

class NestedCurativeTab extends StatefulWidget {
  final String interventionType;
  const NestedCurativeTab({
    required this.interventionType,
    super.key,
  });

  @override
  State<NestedCurativeTab> createState() => _NestedCurativeTabState();
}

class _NestedCurativeTabState extends State<NestedCurativeTab>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar.secondary(
          controller: _tabController,
          tabs: [
            Tab(
              text: disciplineValueList[0],
            ),
            Tab(
              text: disciplineValueList[1],
            ),
            Tab(
              text: disciplineValueList[2],
            )
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              InterventionFilesStream(
                interventionType: widget.interventionType,
                discipline: disciplineValueList[0],
              ),
              InterventionFilesStream(
                interventionType: widget.interventionType,
                discipline: disciplineValueList[1],
              ),
              InterventionFilesStream(
                interventionType: widget.interventionType,
                discipline: disciplineValueList[2],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
