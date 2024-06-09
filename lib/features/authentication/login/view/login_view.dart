import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../password rest/view/password_rest_view.dart';
import '../controller/login_controller.dart';

// LoginPage is a StatefulWidget representing the login screen of the application
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _loginController = LoginController();
  // Variables to manage the visibility of the password
  bool _isObscure = true;

  //Variables to manage the state of the 'Remember Me' checkbox
  bool _isChecked = false;

  // Form key for managing the state of the login form
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Variables to store user email and password inputs
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
                right: 16,
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: SvgPicture.asset(
                      'assets/login_image.svg',
                      height: MediaQuery.sizeOf(context).height / 5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email Address",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
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
                            return Colors.grey;
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
                        // r'''^(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+   # Local part of the email before @
                        //   (?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)* # Additional parts of local part separated by dots
                        //   |                                   # OR
                        //   "(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f  # Quoted string part
                        //   |\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")  # Escaped characters in quoted string
                        //   @                                   # At symbol separating local and domain parts
                        //   (?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?  # First part of the domain
                        //   \.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?   # Additional domain parts
                        //   |\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}   # OR IPv4 address part
                        //   (?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?                 # Final part of IPv4 address
                        //   |[a-z0-9-]*[a-z0-9]:                                     # OR IPv6 address part
                        //   (?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f        # Characters allowed in IPv6
                        //   |\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])$''';              # Closing brackets for IPv6 and email
                        if (!RegExp(
                                r'''^(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)])$''')
                            .hasMatch(value)) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _email = newValue!.trim();
                      },
                      initialValue:
                          _loginController.getCachedEmailFromLocalDB(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Align(
                      alignment: Alignment.bottomLeft,
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
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outlined,
                        ),
                        prefixIconColor: MaterialStateColor.resolveWith(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Theme.of(context).colorScheme.primary;
                            }
                            if (states.contains(MaterialState.error)) {
                              return Theme.of(context).colorScheme.error;
                            }
                            return Colors.grey;
                          },
                        ),
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
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        hintText: "Enter Your Password Here",
                      ),
                      obscureText: _isObscure,
                      // Validator function for password input
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please provide a password";
                        }
                        // Check if the password is at least 8 characters long
                        if (value.length < 6) {
                          return "the password  must be at least 6 characters in length";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _password = newValue!.trim();
                      },
                      initialValue:
                          _loginController.getCachedPasswordFromLocalDB(),
                      // onFieldSubmitted: (_) {
                      //   _formkey.currentState!.validate();
                      //   _formkey.currentState!.save();
                      // },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 200,
                          // 'Remember Me' checkbox
                          child: Row(
                            children: [
                              Checkbox(
                                value: _isChecked,
                                onChanged: (newValue) {
                                  setState(() {
                                    _isChecked = newValue!;
                                  });
                                },
                              ),
                              Text(
                                "Remember you ?",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        // 'Forget Password?' button
                        TextButton(
                          onPressed: () async {
                            showModalBottomSheet(
                              context: context,
                              isDismissible: true,
                              isScrollControlled: true,
                              elevation:
                                  Theme.of(context).bottomSheetTheme.elevation,
                              builder: (context) => const PasswordRestView(),
                            );
                          },
                          child: Text(
                            "Forget Password ?",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: FilledButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            _formkey.currentState!.save();
                            try {
                              await _loginController.loginUser(
                                emailAddress: _email,
                                password: _password,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Login successfully"),
                                  ),
                                );
                              }
                              //saving the credentials in case of a successful login
                              _loginController.rememberMe(
                                isChecked: _isChecked,
                                email: _email,
                                password: _password,
                              );
                            } on FirebaseAuthException catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.message!),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: Text(
                          "Log in",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
