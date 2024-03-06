import "package:flutter/material.dart";

class MyInputField extends StatefulWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  const MyInputField(
      {super.key,
      required this.title,
      required this.hint,
      required this.controller});

  @override
  State<MyInputField> createState() => _MyInputFieldState();
}

class _MyInputFieldState extends State<MyInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Container(
            padding: const EdgeInsets.only(left: 14),
            height: 52,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(12)),
            child: TextFormField(
              autocorrect: false,
              cursorColor: Theme.of(context).colorScheme.primary,
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w400,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
