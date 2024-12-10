import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:organizer_app/Utils/image_helper.dart';

class ImagePickerProvider extends ChangeNotifier {
  final List<File> _mainEventCoverImages = [];
  List<List<File>> _subEventCoverImages = [[]];
  final List<File?> _images = [];
  PlatformFile? _selectedFile;

  File? _mainEventImage;
  File? _profileImage;

  ImageHelper imageHelper = ImageHelper();

  File? get mainEventImage => _mainEventImage;
  File? get profileImage => _profileImage;
  PlatformFile? get selectedFile => _selectedFile;
  List<File?> get images => _images;

  List<File> get mainEventCoverImages => _mainEventCoverImages;
  List<List<File>> get subEventCoverImages => _subEventCoverImages;

  void setSubEventImageList() {
    _subEventCoverImages.add([]);
    notifyListeners();
  }

  get imageFiles => null;

  //<---------- Image Picker -------------------------------->
  Future<void> pickProfileImage() async {
    try {
      final file = await imageHelper.pickImage();
      if (file.isNotEmpty) {
        final croppedFile = await imageHelper.crop(file: file.first!);
        if (croppedFile != null) {
          _profileImage = File(croppedFile.path);
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error picking profile image: $e');
    }
  }

  Future<void> pickMainEventImage() async {
    try {
      final file = await imageHelper.pickImage();
      if (file.isNotEmpty) {
        _mainEventImage = File(file.first!.path);
        notifyListeners();
      }
    } catch (e) {
      print('Error picking main event image: $e');
    }
  }

  Future<void> pickCoverImage(int index,
      {bool isMainEventCoverImages = true}) async {
    try {
      final file = await imageHelper.pickImage();
      if (file.isNotEmpty) {
        if (isMainEventCoverImages) {
          _mainEventCoverImages.add(File(file.first!.path));
        } else {
          if (index < _subEventCoverImages.length) {
            _subEventCoverImages[index].add(File(file.first!.path));
          } else {
            print('Error: Invalid sub-event index.');
          }
        }
        notifyListeners();
      }
    } catch (e) {
      print('Error picking cover image: $e');
    }
  }

  void removeCoverImage(int subIndex, int index,
      {bool deleteMainEventCoverImage = true}) {
    try {
      if (deleteMainEventCoverImage) {
        if (index >= 0 && index < _mainEventCoverImages.length) {
          _mainEventCoverImages.removeAt(index);
          notifyListeners();
        } else {
          print('Error: Invalid index for mainEventCoverImages.');
        }
      } else {
        if (subIndex < _subEventCoverImages.length) {
          if (index >= 0 && index < _subEventCoverImages[subIndex].length) {
            _subEventCoverImages[subIndex].removeAt(index);
            notifyListeners();
          } else {
            print('Error: Invalid index for subEventCoverImages.');
          }
        } else {
          print('Error: Invalid subEvent index.');
        }
      }
    } catch (e) {
      print('Error removing cover image: $e');
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  //<--------- File Picker ----------------------->
  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        _selectedFile = result.files.first;
        notifyListeners();
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  void removeFile() {
    _selectedFile = null;
    notifyListeners();
  }

  void removeMainImage() {
    _mainEventImage = null;
    notifyListeners();
  }

  void deleteImage(int index) {
    _images.removeAt(index);
    notifyListeners();
  }

  void clearImages() {
    _images.clear();
    _mainEventImage = null;
    _mainEventCoverImages.clear();
    _subEventCoverImages = [[]];
    notifyListeners();
  }
}
