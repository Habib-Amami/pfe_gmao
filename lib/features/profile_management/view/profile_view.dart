import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pfe_gmao/features/profile_management/view/alerts/password_update_alert.dart';

import '../../../firebase/firebase_references.dart';
import '../../../firebase/firebase_services.dart';
import '../model/user.dart';
import 'alerts/email_update_alert.dart';
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
        child: StreamBuilder(
          stream: FirebaseService.instance.firestoreInstance
              .collection(userCollectionRef)
              .doc(FirebaseService.instance.authInstance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error = ${snapshot.error}');
            }

            if (snapshot.hasData) {
              UserModel currendtUser =
                  UserModel.fromFirestore(snapshot.data!, null);

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
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
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return ProfilePictureBottomsheet(
                                profileImageURL: currendtUser.photoURL,
                                serialNumber: currendtUser.serialNumber,
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Change Profile Picture",
                        ),
                      ),
                    ),
                    const Divider(
                      endIndent: 16,
                      indent: 16,
                    ),
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
                    const Divider(
                      endIndent: 16,
                      indent: 16,
                    ),
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
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
