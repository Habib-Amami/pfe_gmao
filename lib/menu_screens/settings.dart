import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';

import '../features/profile_management/model/user.dart';
import '../features/profile_management/view/profile_view.dart';
import '../firebase/cloud_firestore_references.dart';
import '../firebase/firebase_services.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingsState();
}

class _SettingsState extends State<Setting> {
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseService.instance.firestoreInstance
          .collection(userCollectionRef)
          .doc(FirebaseService.instance.authInstance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        // Check if data is available in the stream
        else {
          UserModel currentUser = UserModel.fromFirestore(snapshot.data!, null);
          return Scaffold(
            appBar: AppBar(
              title: const Text("Settings"),
              titleTextStyle: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text(
                    //   "Settings",
                    //   style: TextStyle(
                    //     fontSize: 36,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 40,
                    // ),
                    const Text(
                      "Account",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            radius: 50,
                            child: CircleAvatar(
                              radius: 48,
                              backgroundImage:
                                  NetworkImage(currentUser.photoURL),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentUser.userName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  currentUser.role.toShortString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                ),
                              ),
                              icon:
                                  const Icon(Ionicons.chevron_forward_outline),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // language settings
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange.shade100,
                          ),
                          child: const Icon(
                            Ionicons.earth,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          "Language",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        const Spacer(),
                        const Text(
                          "English",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IconButton(
                              onPressed: () {},
                              icon:
                                  const Icon(Ionicons.chevron_forward_outline)),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    // help setting
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green.shade100,
                          ),
                          child: const Icon(
                            Ionicons.help,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          "Help",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        const Spacer(),
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IconButton(
                              onPressed: () {},
                              icon:
                                  const Icon(Ionicons.chevron_forward_outline)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // dark mode setting
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purple.shade100,
                          ),
                          child: const Icon(
                            Ionicons.invert_mode,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          "Dark Mode",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        const Spacer(),
                        Switch(
                          value: isDark,
                          onChanged: (value) {
                            setState(() {
                              isDark = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
