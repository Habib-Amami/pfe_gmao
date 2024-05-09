import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pfe_gmao/features/intervention_files/View/widgets/intervention_file_widgets/curative_file_widget.dart';
import 'package:pfe_gmao/features/intervention_files/View/widgets/intervention_file_widgets/preventive_file_widget.dart';

class InterventionViewPage extends StatefulWidget {
  final String interventionFileID;
  final String interventionFileDiscipline;
  final String interventionType;

  const InterventionViewPage({
    required this.interventionFileID,
    super.key,
    required this.interventionFileDiscipline,
    required this.interventionType,
  });

  @override
  State<InterventionViewPage> createState() => _InterventionViewPage();
}

class _InterventionViewPage extends State<InterventionViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Ionicons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Intervention File Validation',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection(
                'collective_${widget.interventionFileDiscipline}_${widget.interventionType}_intervention_files')
            .doc(widget.interventionFileID)
            .get(),
        builder: ((context, snapshot) {
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
                  Text("Loading Intervention File ...")
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
                  Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ],
              ),
            );
          }
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          List technicians = [];
          data['instrumentTechnician']
              ? technicians.add('Instrument Technician')
              : debugPrint('no instrument');
          data['electricalTechnician']
              ? technicians.add('Electrical Technician')
              : debugPrint('no electrical');
          data['mechanicalTechnician']
              ? technicians.add('Mechanical Technician')
              : debugPrint('no mechanical');
          String technicianList = technicians.join(' - ');
          var spareParts = data['spareParts'].join(' - ');
          var tools = data['tools'].join(' - ');
          //var creationDate = data['CreatedAt'];
          return ListView(
            children: [
              SingleChildScrollView(
                child: widget.interventionType == 'Preventive'
                    ? PreventiveFile(
                        spareParts: spareParts,
                        task: data['interventionTask'],
                        startingDay: data['startingDay'],
                        forecast: data['forecast'],
                        equipmentName: data['equipmentTagName'],
                        equipmentStatus: data['equipmentStatus'],
                        equipmentDiscipline: widget.interventionFileDiscipline,
                        fileName: data['fileName'],
                        interventionType: widget.interventionType,
                        technicians: technicianList,
                        tools: tools,
                      )
                    : CurativeInterventionFileView(
                        equipmentName: data['equipmentTagName'],
                        equipmentStatus: data['equipmentStatus'],
                        equipmentDiscipline: widget.interventionFileDiscipline,
                        fileName: data['fileName'],
                        interventionType: widget.interventionType,
                        criticality: data['criticity'],
                        breakdownType: data['breakDownType'],
                        technicians: technicianList,
                        startingDay: data['startingDay'],
                        tools: tools,
                        spareParts: spareParts,
                        task: data['interventionTask'],
                        breakdownDescription: data['breakDownDescription'],
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
