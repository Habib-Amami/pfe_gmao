import 'package:flutter/material.dart';

import '../../controller/profile_controller.dart';

class EmailUpdateAlert extends StatefulWidget {
  const EmailUpdateAlert({super.key});

  @override
  State<EmailUpdateAlert> createState() => _AlertState();
}

class _AlertState extends State<EmailUpdateAlert> {
  // Create an instance of the ProfileController for managing profile-related actions
  final ProfileController _profileController = ProfileController();

  // Form key for managing the state of the email update form
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  // Variables to manage the visibility of the password
  bool _isObscure = true;

  // Variables to store user email and password inputs
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Adjust the padding, content alignment, and size of the alert dialog
      buttonPadding: const EdgeInsets.all(16),
      icon: const Icon(
        Icons.update,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      titlePadding: const EdgeInsets.symmetric(vertical: 16),
      scrollable: false,
      semanticLabel: "alert dialog for updating the email",
      elevation: 24,
      // Set the title of the alert dialog
      title: Text(
        "Email Update",
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      ),
      // Set the content of the alert dialog with a form for email and password input
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width / 4 * 3,
        height: MediaQuery.sizeOf(context).height / 3,
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextFormField for entering the new email
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 48),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: "Enter your new email",
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please provide your new email";
                    }
                    return null;
                  },
                  onSaved: (newEmail) => _email = newEmail!.trim(),
                ),
              ),
              // TextFormField for entering the password for confirmation
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
                        ? const Icon(
                            Icons.visibility_outlined,
                          )
                        : const Icon(
                            Icons.visibility_off_outlined,
                          ),
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
      // Set the actions (buttons) for the alert dialog
      actions: [
        // Cancel button
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          child: const Text(
            "Cancel",
          ),
        ),
        // Submit button for updating the email
        FilledButton(
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              _formkey.currentState!.save();
              bool isVerified = await _profileController.verifyPassword(
                entredPassword: _password,
              );
              if (isVerified) {
                _profileController.updateEmail(
                  newEmail: _email,
                );
                // Display a success message as a snackbar
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Email updated successfully",
                      ),
                    ),
                  );
                }
              } else {
                // Display an error message as a snackbar for wrong password
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Wrong password",
                      ),
                    ),
                  );
                }
              }
            }
          },
          child: const Text(
            "Submit",
          ),
        ),
      ],
    );
  }
}
