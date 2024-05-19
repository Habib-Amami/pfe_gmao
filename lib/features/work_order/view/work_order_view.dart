import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pfe_gmao/features/work_order/model/data_models/work_order.dart';
import 'package:pfe_gmao/firebase/cloud_firestore_references.dart';

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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(userCollectionRef)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("work_order")
            .snapshots(),
        builder: (context, snapshot) {
          // Handle interruption of connection
          if (snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50.0,
                  ),
                  SizedBox(height: 10.0),
                  Text("Lost connection"),
                ],
              ),
            );
          }
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Loading Work Orders ...")
                ],
              ),
            );
          }
          // Show error message if an error occurs
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const CircularProgressIndicator(),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }
          //if their is data
          List<WorkOrder> workorders = snapshot.data!.docs
              .map(
                (order) => WorkOrder.fromJson(
                  order.data(),
                ),
              )
              .toList();
          //if their is no work orders
          if (workorders.isEmpty) {
            //build a ui when is their is not work orders
            return const Center(
              child: Text("no work orders"),
            );
          }
          return ListView.builder(
            itemCount: workorders.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(workorders[index].equipmentTagName),
            ),
          );
        },
      ),
    );
  }
}
