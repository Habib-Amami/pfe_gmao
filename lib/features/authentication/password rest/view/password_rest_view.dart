import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../password%20rest/controller/password_rest_controller.dart';

class PasswordRestView extends StatefulWidget {
  const PasswordRestView({super.key});

  @override
  State<PasswordRestView> createState() => _PasswordRestViewState();
}

class _PasswordRestViewState extends State<PasswordRestView> {
  final PasswordRestController _passwordRestController =
      PasswordRestController();

  // Form key for managing the state of the login form
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String _email = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height / 7 * 6,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  "Forgot your Password?",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Text(
                  "Enter your email address and we will share a \n link to create a new password.",
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Form(
                  key: _formkey,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      focusColor: Theme.of(context).colorScheme.primary,
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
                          Radius.circular(16),
                        ),
                      ),
                      hintText: "Enter Your Email Here",
                    ),
                    validator: (value) {
                      //create a email validation
                      if (value == null || value.isEmpty) {
                        return "please provide an email";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _email = newValue!;
                    },
                    // onFieldSubmitted: (_) {
                    //   _formkey.currentState!.validate();
                    //   _formkey.currentState!.save();
                    // },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: FilledButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        try {
                          _formkey.currentState!.save();
                          await _passwordRestController
                              .passwordRestUser(
                                email: _email,
                              )
                              .then(
                                (_) => Navigator.pop(context),
                              );

                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'Email send successfully !',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                  ),
                                  content: const Text(
                                    'password rest email was send the email that you provided, Check your in box and make sure to update your password',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (context.mounted) {
                            return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'Error !',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                  ),
                                  content: Text(
                                    e.message.toString(),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.send_outlined),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          "Send",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
