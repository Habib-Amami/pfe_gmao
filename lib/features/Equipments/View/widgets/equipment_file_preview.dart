import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_filex/open_filex.dart';

class FilePreviewContainer extends StatelessWidget {
  final File? file;
  final void Function()? onFileDeleted;

  const FilePreviewContainer({
    required this.file,
    this.onFileDeleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          color:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SvgPicture.asset(
                Theme.of(context).brightness == Brightness.light
                    ? "assets/light_pdf.svg"
                    : "assets/dark_pdf.svg",
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => OpenFilex.open(file!.path),
                child: Text(
                  file!.path.split("/").last,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            IconButton(
              onPressed: onFileDeleted,
              icon: const Icon(Icons.cancel_outlined),
            )
          ],
        ),
      ),
    );
  }
}
