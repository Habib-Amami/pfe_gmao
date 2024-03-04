import 'package:flutter/material.dart';

import '../../controller/profile_controller.dart';

class UsernameUpdateAlert extends StatefulWidget {
  const UsernameUpdateAlert({super.key});

  @override
  State<UsernameUpdateAlert> createState() => _AlertState();
}

class _AlertState extends State<UsernameUpdateAlert> {
  final ProfileController _profileController = ProfileController();
  // Form key for managing the state of the login form
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  // Variables to manage the visibility of the password
  bool _isObscure = true;

  // Variables to store user email and password inputs
  String _username = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      buttonPadding: const EdgeInsets.all(16),
      icon: const Icon(
        Icons.update,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      titlePadding: const EdgeInsets.symmetric(vertical: 16),
      scrollable: false,
      semanticLabel: "alert dialog for updating the username",
      elevation: 24,
      title: Text(
        "Username Update",
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width / 4 * 3,
        height: MediaQuery.sizeOf(context).height / 3,
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 48),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: "Enter your new username",
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please provide your new username";
                    }
                    return null;
                  },
                  onSaved: (newUsername) => _username = newUsername!.trim(),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Your password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    // Toggle visibility of the password with an icon button
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: _isObscure
                        ? const Icon(Icons.visibility_outlined)
                        : const Icon(Icons.visibility_off_outlined),
                  ),
                ),
                obscureText: _isObscure,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please provide your password";
                  }
                  // Check if the password is at least 6 characters long
                  if (value.length < 6) {
                    return "the password  must be at least 6 characters in length";
                  }
                  return null;
                },
                onSaved: (newPassword) => _password = newPassword!.trim(),
              )
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              _formkey.currentState!.save();
              bool isVerified = await _profileController.verifyPassword(
                entredPassword: _password,
              );
              if (isVerified) {
                await _profileController.updateUserName(newUserName: _username);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Username updated successfully"),
                    ),
                  );
                }
              } else {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Wrong password"),
                    ),
                  );
                }
              }
            }
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
