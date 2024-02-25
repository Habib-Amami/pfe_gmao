import 'package:flutter/material.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  State<EquipmentScreen> createState() => _EquipmentSreenState();
}

class _EquipmentSreenState extends State<EquipmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () {
          debugPrint("item added!");
        },
        child: const Icon(Icons.library_add),
      ),
      body: SafeArea(
        child: ListView(
          children: const [
            ExpansionTile(
              leading: SizedBox(
                height: 10,
                width: 10,
                child: Placeholder(
                  color: Colors.amber,
                ),
              ),
              title: Text('Equipment Name'),
              subtitle: Text('Description'),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'more details about the equipment',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: SizedBox(
                height: 10,
                width: 10,
                child: Placeholder(
                  color: Colors.amber,
                ),
              ),
              title: Text('Equipment Name'),
              subtitle: Text('Description'),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'more details about the equipment',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: SizedBox(
                height: 10,
                width: 10,
                child: Placeholder(
                  color: Colors.amber,
                ),
              ),
              title: Text('Equipment Name'),
              subtitle: Text('Description'),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'more details about the equipment',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: SizedBox(
                height: 10,
                width: 10,
                child: Placeholder(
                  color: Colors.amber,
                ),
              ),
              title: Text('Equipment Name'),
              subtitle: Text('Description'),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'more details about the equipment',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: SizedBox(
                height: 10,
                width: 10,
                child: Placeholder(
                  color: Colors.amber,
                ),
              ),
              title: Text('Equipment Name'),
              subtitle: Text('Description'),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'more details about the equipment',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: SizedBox(
                height: 10,
                width: 10,
                child: Placeholder(
                  color: Colors.amber,
                ),
              ),
              title: Text('Equipment Name'),
              subtitle: Text('Description'),
              children: [
                ListTile(
                  title: Text(
                    'more details about the equipment',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: SizedBox(
                height: 10,
                width: 10,
                child: Placeholder(
                  color: Colors.amber,
                ),
              ),
              title: Text('Equipment Name'),
              subtitle: Text('Description'),
              children: [
                ListTile(
                  title: Text(
                    'more details about the equipment',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: SizedBox(
                height: 10,
                width: 10,
                child: Placeholder(
                  color: Colors.amber,
                ),
              ),
              title: Text('Equipment Name'),
              subtitle: Text('Description'),
              children: [
                ListTile(
                  title: Text(
                    'more details about the equipment',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: SizedBox(
                height: 10,
                width: 10,
                child: Placeholder(
                  color: Colors.amber,
                ),
              ),
              title: Text('Equipment Name'),
              subtitle: Text('Description'),
              children: [
                ListTile(
                  title: Text(
                    'more details about the equipment',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: SizedBox(
                height: 10,
                width: 10,
                child: Placeholder(
                  color: Colors.amber,
                ),
              ),
              title: Text('Equipment Name'),
              subtitle: Text('Description'),
              children: [
                ListTile(
                  title: Text(
                    'more details about the equipment',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: SizedBox(
                height: 10,
                width: 10,
                child: Placeholder(
                  color: Colors.amber,
                ),
              ),
              title: Text('Equipment Name'),
              subtitle: Text('Description'),
              children: [
                ListTile(
                  title: Text(
                    'more details about the equipment',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
