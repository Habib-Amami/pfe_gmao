import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pfe_gmao/features/profile_management/model/user.dart';
import 'package:pfe_gmao/features/work_order/model/data_models/work_order.dart';
import 'package:pfe_gmao/features/work_order/view/work%20order%20view/admin_wo_view.dart';
import 'package:pfe_gmao/features/work_order/view/work%20order%20view/engineer_wo_view.dart';
import 'package:pfe_gmao/firebase/cloud_firestore_references.dart';

class WorkOrderView extends StatefulWidget {
  const WorkOrderView({super.key});

  @override
  State<WorkOrderView> createState() => _WorkOrderViewState();
}

class _WorkOrderViewState extends State<WorkOrderView> {
  DateTime today = DateTime.now();
  late UserModel user;

  //method to fetch the admin data
  Future<bool> adminCheck() async {
    await FirebaseFirestore.instance
        .collection(userCollectionRef)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (snapshot) {
        user = UserModel.fromFirestore(snapshot, null);
      },
    );

    return user.role == Roles.Administrator;
  }

  void fecthUserRole() async {
    isAdmin = await adminCheck();
  }

  bool isAdmin = false;

  @override
  void initState() {
    fecthUserRole();
    super.initState();
  }

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
          List<WorkOrder> workOrders = snapshot.data!.docs
              .map(
                (order) => WorkOrder.fromJson(
                  order.data(),
                ),
              )
              .toList();
          //if their is no work orders
          if (workOrders.isEmpty) {
            //build a ui when is their is not work orders
            return const Center(
              child: Text("no work orders"),
            );
          }
          return ListView.builder(
            itemCount: workOrders.length,
            itemBuilder: (context, index) => ListTile(
              title: GestureDetector(
                onTap: () {
                  isAdmin
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminWorkOrderView(
                              interventionId: workOrders[index].interventionID,
                              workOrderID: workOrders[index].workorderID,
                            ),
                          ),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EngineerWorkOrderView(
                              interventionId: workOrders[index].interventionID,
                              workOrderID: workOrders[index].workorderID,
                            ),
                          ),
                        );
                },
                child: Card(
                  child: Text(workOrders[index].equipmentTagName),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
