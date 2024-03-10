import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pfe_gmao/features/profile_management/view/alerts/camera_permission_denied_alert.dart';

import '../../../firebase/cloud_firestore_references.dart';
import '../../../firebase/firebase_services.dart';
import '../model/user.dart';
import 'alerts/email_update_alert.dart';
import 'alerts/password_update_alert.dart';
import 'alerts/phone_number_update_alert.dart';
import 'alerts/username_update_alert.dart';
import 'profile_picture_bottom_sheet/profile_picture_bottom_sheet.dart';

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
                        radius: 50,
                        child: CircleAvatar(
                          radius: 48,
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
                                    const CameraPermissionDeniedAlert(),
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
                                    const CameraPermissionDeniedAlert(),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Profile Information",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    // Slidable widget for editable username
                    Slidable(
                      startActionPane: ActionPane(
                        extentRatio: 0.25,
                        dragDismissible: true,
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            onPressed: (context) {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const UsernameUpdateAlert(),
                                barrierDismissible: false,
                              );
                            },
                            icon: Icons.edit_outlined,
                            label: "Edit",
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const SizedBox(
                              width: 100,
                              child: Text("Username :"),
                            ),
                            Text(currendtUser.userName),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                            )
                          ],
                        ),
                      ),
                    ),
                    // Slidable widget for editable email
                    Slidable(
                      startActionPane: ActionPane(
                        extentRatio: 0.2,
                        dragDismissible: true,
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            onPressed: (context) {
                              showDialog(
                                context: context,
                                builder: (context) => const EmailUpdateAlert(),
                                barrierDismissible: false,
                              );
                            },
                            icon: Icons.edit_outlined,
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const SizedBox(
                              width: 100,
                              child: Text(
                                "Email :",
                              ),
                            ),
                            Flexible(
                              child: Text(
                                currendtUser.email,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                            )
                          ],
                        ),
                      ),
                    ),
                    // Button to update password
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            elevation: MaterialStatePropertyAll(2)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const PasswordUpdateAlert(),
                            barrierDismissible: false,
                          );
                        },
                        child: const Text("Update Password"),
                      ),
                    ),
                    // Divider for visual separation
                    const Divider(
                      endIndent: 16,
                      indent: 16,
                    ),
                    // Section for Personal Information
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Personal Information",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    // Slidable widget for editable phone number
                    Slidable(
                      startActionPane: ActionPane(
                        extentRatio: 0.25,
                        dragDismissible: true,
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            onPressed: (context) {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const PhoneNumberUpdateAlert(),
                                barrierDismissible: false,
                              );
                            },
                            icon: Icons.edit_outlined,
                            label: "Edit",
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const SizedBox(
                              width: 140,
                              child: Text("Phone Number :"),
                            ),
                            Text(currendtUser.phoneNumber),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                            )
                          ],
                        ),
                      ),
                    ),
                    // Display Serial Number
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const SizedBox(
                            width: 140,
                            child: Text("Serial Number :"),
                          ),
                          Text(currendtUser.serialNumber),
                        ],
                      ),
                    ),
                    // Display user's role
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const SizedBox(
                            width: 140,
                            child: Text("Role :"),
                          ),
                          Text(currendtUser.role.toShortString()),
                        ],
                      ),
                    ),
                    // Buttons to edit profile and log out
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 160,
                            height: 48,
                            child: FilledButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text("Edit Profile "),
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
                              icon: const Icon(Icons.exit_to_app_outlined),
                              label: const Text("Log Out"),
                            ),
                          ),
                        ],
                      ),
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
