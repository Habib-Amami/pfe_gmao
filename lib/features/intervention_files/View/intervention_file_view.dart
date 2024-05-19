import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../model/data_models/intervention_file_status.dart';
import 'widgets/file_status_rectangular_widgets/confirmed_status.dart';
import 'widgets/file_status_rectangular_widgets/denied_status.dart';
import 'widgets/intervention_file_widgets/curative_file_widget.dart';
import 'widgets/intervention_file_widgets/preventive_file_widget.dart';

class InterventionFileViewPage extends StatefulWidget {
  //final String interventionFileCreatorID;
  //final String interventionFileCreatorToken;
  final String interventionFileID;
  final String interventionType;
  // final String equipmentID;
  // final String equipmentTagName;
  final String equipmentDiscipline;

  const InterventionFileViewPage({
    required this.interventionFileID,
    super.key,
    required this.interventionType,
    required this.equipmentDiscipline,
  });

  @override
  State<InterventionFileViewPage> createState() => _InterventionFileViewPage();
}

class _InterventionFileViewPage extends State<InterventionFileViewPage> {
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
          'Intervention File',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection(
                'collective_${widget.equipmentDiscipline}_${widget.interventionType}_intervention_files')
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
                        equipmentDiscipline: widget.equipmentDiscipline,
                        fileName: data['fileName'],
                        interventionType: widget.interventionType,
                        technicians: technicianList,
                        tools: tools,
                      )
                    : CurativeInterventionFileView(
                        equipmentName: data['equipmentTagName'],
                        equipmentStatus: data['equipmentStatus'],
                        equipmentDiscipline: widget.equipmentDiscipline,
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
                        // creationDate: DateFormat(
                        //   'dd-MM-yyyy',
                        // ).format(
                        //   DateTime.fromMillisecondsSinceEpoch(
                        //     creationDate.seconds * 1000,
                        //   ),
                        // ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 25),
                child:
                    // If the intervention file is still in progress
                    data['fileStatus'] == interventionFileStatus[2]
                        ? Container(
                            width: double.infinity,
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                'This intervention file still in review',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          )
                        : data['fileStatus'] == interventionFileStatus[0]
                            ? const ConfirmedState()
                            : const DeniedState(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
