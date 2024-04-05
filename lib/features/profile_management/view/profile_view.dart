import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pfe_gmao/features/profile_management/view/widgets/bottom_sheets/edit_profile_bottom_sheet.dart';

import '../../../firebase/cloud_firestore_references.dart';
import '../../../firebase/firebase_services.dart';
import '../model/user.dart';
import 'widgets/alerts/email_update_alert.dart';
import 'widgets/alerts/password_update_alert.dart';
import 'widgets/alerts/profile_camera_permission_denied_alert.dart';
import 'widgets/alerts/username_update_alert.dart';
import 'widgets/bottom_sheets/profile_picture_bottom_sheet.dart';
import 'widgets/editiable_row_slidable.dart';
import 'widgets/labeled_value_row.dart';
import 'widgets/section_title.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        // StreamBuilder to listen for changes in user data
        child: StreamBuilder(
          stream: FirebaseService.instance.firestoreInstance
              .collection(userCollectionRef)
              .doc(FirebaseService.instance.authInstance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            // Check for errors in the stream
            if (snapshot.hasError) {
              return Text('Error = ${snapshot.error}');
            }
            // Check if data is available in the stream
            if (snapshot.hasData) {
              // Create UserModel instance from snapshot data
              UserModel currendtUser =
                  UserModel.fromFirestore(snapshot.data!, null);
              // UI layout for the profile screen
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Display user's profile picture
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        radius: 70,
                        child: CircleAvatar(
                          radius: 66,
                          backgroundImage: NetworkImage(currendtUser.photoURL),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          elevation: MaterialStatePropertyAll(2),
                        ),
                        onPressed: () async {
                          await Permission.camera.onDeniedCallback(() {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const ProfileCameraPermissionDeniedAlert(),
                              );
                            }
                          }).onGrantedCallback(() {
                            if (context.mounted) {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ProfilePictureBottomsheet(
                                    profileImageURL: currendtUser.photoURL,
                                    serialNumber: currendtUser.serialNumber,
                                  );
                                },
                              );
                            }
                          }).onPermanentlyDeniedCallback(() {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const ProfileCameraPermissionDeniedAlert(),
                              );
                            }
                          }).request();
                        },
                        child: const Text(
                          "Change Profile Picture",
                        ),
                      ),
                    ),
                    // Divider for visual separation
                    const Divider(
                      endIndent: 16,
                      indent: 16,
                    ),
                    // Section for Profile Information
                    const SectionTitle(
                      sectionTile: "Profile Information",
                    ),
                    // Slidable widget for editable username
                    EditableRowWithSlidable(
                      title: "Username :",
                      content: currendtUser.userName,
                      contentStyle: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                      titleContentSeperator: 100,
                      onEditPressed: (contex) => showDialog(
                        context: context,
                        builder: (context) => const UsernameUpdateAlert(),
                        barrierDismissible: false,
                      ),
                    ),
                    // Slidable widget for editable email
                    EditableRowWithSlidable(
                      title: "Email :",
                      content: currendtUser.email,
                      contentStyle: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                      titleContentSeperator: 100,
                      onEditPressed: (contex) => showDialog(
                        context: context,
                        builder: (context) => const EmailUpdateAlert(),
                        barrierDismissible: false,
                      ),
                    ),
                    // Button to update password
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ElevatedButton.icon(
                        style: const ButtonStyle(
                            elevation: MaterialStatePropertyAll(2)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const PasswordUpdateAlert(),
                            barrierDismissible: false,
                          );
                        },
                        label: const Text(
                          "Update Password",
                        ),
                        icon: const Icon(
                          Icons.lock_rounded,
                        ),
                      ),
                    ),
                    // Divider for visual separation
                    const Divider(
                      endIndent: 16,
                      indent: 16,
                    ),
                    // Section for Personal Information
                    const SectionTitle(
                      sectionTile: "Personal Information",
                    ),
                    // Slidable widget for editable phone number
                    EditableRowWithSlidable(
                      title: "Phone Number :",
                      content: currendtUser.phoneNumber,
                      contentStyle: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                      titleContentSeperator: 140,
                      onEditPressed: (contex) => showDialog(
                        context: context,
                        builder: (context) => const UsernameUpdateAlert(),
                        barrierDismissible: false,
                      ),
                    ),
                    // Display Serial Number
                    LabeledValueRow(
                      label: "Serial Number :",
                      value: currendtUser.serialNumber,
                      labelWidth: 140,
                    ),
                    // Display user's role
                    LabeledValueRow(
                      label: "Role :",
                      value: currendtUser.role.toShortString(),
                      labelWidth: 140,
                    ),
                    // Buttons to edit profile and log out
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 160,
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: () => showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: true,
                              enableDrag: true,
                              context: context,
                              builder: (context) {
                                return const EditProfileBottomSheet();
                              },
                            ),

                            // onPressed: () => showDialog(
                            //   builder: (context) => const EditProfileAlert(),
                            //   context: context,
                            //   barrierDismissible: false,
                            // ),
                            icon: const Icon(
                              Icons.edit_rounded,
                            ),
                            label: const Text(
                              "Edit Profile",
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          height: 48,
                          child: ElevatedButton.icon(
                            style: const ButtonStyle(
                                elevation: MaterialStatePropertyAll(2)),
                            onPressed: () async {
                              await FirebaseService.instance.authInstance
                                  .signOut();
                              if (context.mounted) {
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              }
                            },
                            icon: const Icon(
                              Icons.exit_to_app_outlined,
                            ),
                            label: const Text(
                              "Log Out",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            // Show loading indicator while data is being fetched
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
