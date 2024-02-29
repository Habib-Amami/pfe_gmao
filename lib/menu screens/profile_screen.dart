import 'package:flutter/material.dart';
import 'package:pfe_gmao/firebase_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseService.instance.authInstance.signOut();
            if (context.mounted) {
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
          child: const Icon(Icons.exit_to_app_outlined),
        ),
      ),
    );
  }
}
