import 'package:flutter/material.dart';

class PasswordRestBottomSheet extends StatelessWidget {
  PasswordRestBottomSheet({super.key});

  // Variables to store user email and password inputs
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
                child: TextField(
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
                  // validator: (value) {
                  //   //create a email validation
                  //   if (value == null || value.isEmpty) {
                  //     return "please provide an email";
                  //   }
                  //   return null;
                  // },
                  // onSaved: (newValue) {
                  //   _email = newValue!;
                  // },
                  // onFieldSubmitted: (_) {
                  //   _textFieldKey.currentState!.validate();
                  //   _textFieldKey.currentState!.save();
                  // },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: FilledButton(
                    onPressed: () {},
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
