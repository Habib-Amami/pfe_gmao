import 'package:flutter/material.dart';
import 'package:pfe_gmao/firebase_services.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => FirebaseService.instance.authInstance.signOut(),
          child: const Icon(Icons.exit_to_app_outlined),
        ),
      ),
    );
  }
}
