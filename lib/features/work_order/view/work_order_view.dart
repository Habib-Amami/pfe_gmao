import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../firebase/cloud_firestore_references.dart';
import '../../profile_management/model/user.dart';
import '../model/data_models/work_order.dart';
import 'widgets/work_order_card.dart';
import 'work%20order%20view/admin_wo_view.dart';
import 'work%20order%20view/engineer_wo_view.dart';

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
            .orderBy('executionDay', descending: true)
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
            if (Theme.of(context).brightness == Brightness.light) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/animations/no_work_order_light.json",
                      width: 150,
                      height: 150,
                      repeat: false,
                    ),
                    Text(
                      "You Don't Have any Work Orders Yet !",
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/animations/no_work_order_dark.json",
                      repeat: false,
                      width: 150,
                      height: 150,
                    ),
                    Text(
                      "You Don't Have any Work Orders Yet !",
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }
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
                                interventionId:
                                    workOrders[index].interventionID,
                                workOrderID: workOrders[index].workorderID,
                              ),
                            ),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EngineerWorkOrderView(
                                interventionId:
                                    workOrders[index].interventionID,
                                workOrderID: workOrders[index].workorderID,
                              ),
                            ),
                          );
                  },
                  child: WorkOrderCard(
                    date: workOrders[index].executionDay,
                    status: workOrders[index].workorderStatus,
                    interventionType: workOrders[index].interventionType,
                    woID: workOrders[index].workorderID,
                    startingTime: workOrders[index].startTime,
                    finishingTime: workOrders[index].finishTime,
                  )),
            ),
          );
        },
      ),
    );
  }
}
