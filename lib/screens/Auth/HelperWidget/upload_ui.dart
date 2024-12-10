import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // For file picking
import 'package:open_file/open_file.dart'; // To open files in external apps

class UploadSection extends StatefulWidget {
  const UploadSection({super.key});

  @override
  _UploadSectionState createState() => _UploadSectionState();
}

class _UploadSectionState extends State<UploadSection> {
  PlatformFile? _selectedDocument;
  List<PlatformFile> _selectedImages = [];

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedDocument = result.files.first;
      });
    }
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _selectedImages = result.files;
      });
    }
  }

  void _openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  void _removeDocument() {
    setState(() {
      _selectedDocument = null;
    });
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Document Upload Container
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.attach_file),
            label: const Text("Upload Document"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF46BCC3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),

        // Display Selected Document
        if (_selectedDocument != null)
          Stack(
            children: [
              GestureDetector(
                onTap: () => _openFile(_selectedDocument!),
                child: Card(
                  color: Colors.white.withOpacity(0.9),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading:
                        const Icon(Icons.picture_as_pdf, color: Colors.red),
                    title: Text(_selectedDocument!.name),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: _removeDocument,
                ),
              ),
            ],
          ),

        // Image Upload Container
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: _pickImages,
            icon: const Icon(Icons.image),
            label: const Text("Upload ID Card Images"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF46BCC3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),

        // Display Selected Images
        if (_selectedImages.isNotEmpty)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _selectedImages.asMap().entries.map((entry) {
              int index = entry.key;
              PlatformFile file = entry.value;

              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(file.path!),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => _removeImage(index),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
      ],
    );
  }
}
