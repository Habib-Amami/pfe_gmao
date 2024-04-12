import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../controller/profile_controller.dart';

class EditProfileBottomSheet extends StatefulWidget {
  const EditProfileBottomSheet({super.key});

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  // Variables to manage the visibility of the password
  bool _isObscure = true;

  // Form key for managing the state of the login form
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  // Create an instance of the ProfileController for managing profile-related actions
  final ProfileController _profileController = ProfileController();

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Variables to store user email and password inputs
  String _userName = "";
  String _email = "";
  String _phoneNumber = "";
  String _password = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height / 8 * 7,
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "User Name",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                    ),
                    prefixIconColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.focused)) {
                          return Theme.of(context).colorScheme.primary;
                        }
                        if (states.contains(MaterialState.error)) {
                          return Theme.of(context).colorScheme.error;
                        }
                        return Colors.black54;
                      },
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    hintText: "Enter your new username",
                  ),
                  validator: (value) {
                    //create a email validation
                    if (value == null || value.isEmpty) {
                      return "Please provide your new username";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _userName = newValue!.trim();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                    ),
                    prefixIconColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.focused)) {
                          return Theme.of(context).colorScheme.primary;
                        }
                        if (states.contains(MaterialState.error)) {
                          return Theme.of(context).colorScheme.error;
                        }
                        return Colors.black54;
                      },
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    hintText: "Enter your new email",
                  ),
                  validator: (value) {
                    //create a email validation
                    if (value == null || value.isEmpty) {
                      return "please provide your new email";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _email = newValue!.trim();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Phone Number",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              IntlPhoneField(
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: "New phone number",
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
                initialCountryCode: "TN",
                onSaved: (newPhoneNumber) {
                  _phoneNumber =
                      newPhoneNumber!.completeNumber.toString().trim();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
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
                    onSaved: (newPassword) {
                      _password = newPassword!.trim();
                    }),
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
                        style: const ButtonStyle(
                          elevation: MaterialStatePropertyAll(2),
                        ),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            _formkey.currentState!.save();
                            // Verify the entered password
                            bool isVerified =
                                await _profileController.verifyPassword(
                              entredPassword: _password,
                            );
                            if (isVerified) {
                              try {
                                // Update the username
                                await _profileController.updateUserName(
                                  newUserName: _userName,
                                );
                                //Updating the email
                                _profileController.updateEmail(
                                  newEmail: _email,
                                );
                                // Update the phone number
                                await _profileController.updatePhoneNumber(
                                  newPhoneNumber: _phoneNumber,
                                );
                              } catch (e) {
                                if (context.mounted) {
                                  // Display an error message as a snackbar for phone number update failure
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Error: Unable to edit profile",
                                      ),
                                    ),
                                  );
                                }
                              }

                              if (context.mounted) {
                                Navigator.pop(context);
                                // Display a success message as a snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Profile updated successfully",
                                    ),
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
                        icon: const Icon(
                          Icons.check,
                        ),
                        label: const Text(
                          "Confirm",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: const ButtonStyle(
                          elevation: MaterialStatePropertyAll(2),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel,
                        ),
                        label: const Text(
                          "Cancel",
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
