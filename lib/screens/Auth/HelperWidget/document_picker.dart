import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:organizer_app/Provider/image_picker_provider.dart';
import 'package:organizer_app/Utils/const_color.dart';

class DocumentPickerWidget extends StatelessWidget {
  const DocumentPickerWidget({
    super.key,
    required this.filePickerProvider,
    required this.selectedFile,
  });

  final ImagePickerProvider filePickerProvider;
  final PlatformFile? selectedFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: selectedFile == null
          ? GestureDetector(
              onTap: filePickerProvider.pickFile,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.attach_file,
                      size: 30,
                      color: Colors.grey[600],
                    ),
                    Text(
                      "Upload Document [PDF only]",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const Icon(Icons.add, color: primaryColor),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf,
                      color: Colors.red, size: 40),
                  title: Text(selectedFile!.name),
                  onTap: () => OpenFile.open(selectedFile!.path),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: filePickerProvider.removeFile,
                  ),
                ),
              ],
            ),
    );
  }
}
