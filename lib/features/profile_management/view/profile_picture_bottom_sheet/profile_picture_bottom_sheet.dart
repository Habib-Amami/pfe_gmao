import 'package:flutter/material.dart';

class ProfilePictureBottomsheet extends StatelessWidget {
  const ProfilePictureBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: CircleAvatar(
                radius: 60,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text("Pick an image from :"),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(2)),
                    onPressed: () {},
                    child: const Text("Gallory"),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(2)),
                    onPressed: () {},
                    child: const Text("Camera"),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 160,
              child: FilledButton(
                onPressed: () {},
                child: const Text("Save"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
