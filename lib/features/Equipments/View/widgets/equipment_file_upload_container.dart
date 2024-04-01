import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadContainer extends StatelessWidget {
  final String label;
  final Function(List<File>?)? onFileSelected;
  final bool allowMultiple;

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
              final files = await getPDF(allowMultiple: allowMultiple);
              if (onFileSelected != null) {
                onFileSelected!(files);
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

  static Future<List<File>?> getPDF({bool allowMultiple = false}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      return files;
    } else {
      return null;
    }
  }
}
