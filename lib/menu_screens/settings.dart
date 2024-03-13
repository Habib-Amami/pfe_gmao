import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../features/profile_management/view/profile_view.dart';
import '../home.dart';
import 'notification_screen.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingsState();
}

class _SettingsState extends State<Setting> {
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Ionicons.chevron_back_outline),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Home()));
          },
        ),
        leadingWidth: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/pngegg.png",
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(width: 20),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "David Clarissa",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Mechanical Engineer",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
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
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfileScreen())),
                        icon: const Icon(Ionicons.chevron_forward_outline)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Row(
              children: [
                Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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
                const SizedBox(width: 20),
                const Text(
                  "Language",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const Spacer(),
                const Text(
                  "English",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w400),
                ),
                const SizedBox(width: 15),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Ionicons.chevron_forward_outline)),
                )
              ],
            ),
            const SizedBox(height: 15),
            // Notification setting
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade100,
                  ),
                  child: const Icon(
                    Ionicons.notifications,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 20),
                const Text(
                  "Notifications",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationScreen())),
                      icon: const Icon(Ionicons.chevron_forward_outline)),
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
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
                      icon: const Icon(Ionicons.chevron_forward_outline)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
