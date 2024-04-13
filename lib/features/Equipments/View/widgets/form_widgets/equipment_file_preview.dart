import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_filex/open_filex.dart';

// Widget for displaying a file preview container
class FilePreviewContainer extends StatelessWidget {
  final File? file; // File object representing the file to preview
  final void Function()?
      onFileDeleted; // Callback function for when file is deleted

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
        // Row for displaying file preview content
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              // SVG image widget for file preview
              child: SvgPicture.asset(
                Theme.of(context).brightness ==
                        Brightness.light // Check theme brightness for SVG color
                    ? "assets/light_pdf.svg" // Light theme SVG asset
                    : "assets/dark_pdf.svg", // Dark theme SVG asset
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              // GestureDetector for handling file tap
              child: GestureDetector(
                onTap: () =>
                    OpenFilex.open(file!.path), // Open file when tapped
                // Text widget for displaying file name
                child: Text(
                  file!.path
                      .split("/")
                      .last, // Extract file name from file path
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            IconButton(
              // Callback function when button is pressed
              onPressed: onFileDeleted,
              icon: const Icon(Icons.cancel_outlined),
            )
          ],
        ),
      ),
    );
  }
}
