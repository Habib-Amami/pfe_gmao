import 'package:flutter/material.dart';

import '../../controller/profile_controller.dart';

class UsernameUpdateAlert extends StatefulWidget {
  const UsernameUpdateAlert({super.key});

  @override
  State<UsernameUpdateAlert> createState() => _AlertState();
}

class _AlertState extends State<UsernameUpdateAlert> {
  // Create an instance of the ProfileController for managing profile-related actions
  final ProfileController _profileController = ProfileController();

  // Form key for managing the state of the username update form
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  // Variable to manage the visibility of the password
  bool _isObscure = true;

  // Variables to store user's new username and password
  String _username = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Adjust the padding, content alignment, and size of the alert dialog
      buttonPadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      titlePadding: const EdgeInsets.symmetric(vertical: 16),
      scrollable: false,
      semanticLabel: "alert dialog for updating the username",
      elevation: 24,
      // Set the icon and title of the alert dialog
      icon: const Icon(
        Icons.update,
      ),
      title: Text(
        "Username Update",
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      ),
      // Set the content of the alert dialog with a form for new username and password input
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width / 4 * 3,
        height: MediaQuery.sizeOf(context).height / 3,
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextFormField for entering the new username
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
                      return "Please provide your new username";
                    }
                    return null;
                  },
                  onSaved: (newUsername) => _username = newUsername!.trim(),
                ),
              ),
              // TextFormField for entering the password
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Your password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
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
                    return "Please provide your password";
                  }
                  // Check if the password is at least 6 characters long
                  if (value.length < 6) {
                    return "The password must be at least 6 characters in length";
                  }
                  return null;
                },
                onSaved: (newPassword) => _password = newPassword!.trim(),
              )
            ],
          ),
        ),
      ),
      // Set the actions (buttons) for the alert dialog
      actions: [
        // Cancel button
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        // Submit button for updating the username
        FilledButton(
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              _formkey.currentState!.save();
              // Verify the entered password
              bool isVerified = await _profileController.verifyPassword(
                entredPassword: _password,
              );
              if (isVerified) {
                try {
                  // Update the username
                  await _profileController.updateUserName(
                    newUserName: _username,
                  );
                } catch (e) {
                  if (context.mounted) {
                    // Display an error message as a snackbar for username update failure
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Error: Unable to update username"),
                      ),
                    );
                  }
                }

                if (context.mounted) {
                  Navigator.pop(context);
                  // Display a success message as a snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Username updated successfully"),
                    ),
                  );
                }
              } else {
                if (context.mounted) {
                  Navigator.pop(context);
                  // Display an error message as a snackbar for wrong password
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
