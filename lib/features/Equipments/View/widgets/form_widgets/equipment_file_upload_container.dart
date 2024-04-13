import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

// Widget for uploading files
class FileUploadContainer extends StatelessWidget {
  final String label; // Label for the file upload container
  final Function(List<File>?)?
      onFileSelected; // Callback function when file(s) are selected
  final bool allowMultiple; // Flag to allow multiple file selection

  const FileUploadContainer({
    required this.allowMultiple,
    this.onFileSelected,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () async {
          // Handle file permissions and file picking
          await Permission.manageExternalStorage.onGrantedCallback(
            () async {
              final files =
                  await getPDF(allowMultiple: allowMultiple); // Get PDF files
              if (onFileSelected != null) {
                onFileSelected!(
                    files); // Call callback function with selected files
              }
            },
          ).request();
        },
        child: Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          // Column for arranging upload icon and label vertically
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_upload_outlined),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall,
              )
            ],
          ),
        ),
      ),
    );
  }

  // Function for getting PDF files
  static Future<List<File>?> getPDF({bool allowMultiple = false}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      // Pick PDF files
      allowMultiple: allowMultiple, // Allow multiple file selection
      type: FileType.custom, // File type
      allowedExtensions: ['pdf'], // Allowed file extensions
    );

    if (result != null) {
      // If files are selected
      List<File> files = result.paths
          .map((path) => File(path!))
          .toList(); // Convert file paths to File objects
      return files; // Return the list of files
    } else {
      return null; // Return null if no files are selected
    }
  }
}
