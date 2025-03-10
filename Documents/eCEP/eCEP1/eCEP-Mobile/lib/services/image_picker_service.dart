import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  // Sélectionner une image depuis la galerie
  Future<File?> pickImageFromGallery(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aucune image sélectionnée')),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection de l\'image : $e')),
      );
      return null;
    }
  }

  // Prendre une photo avec la caméra
  Future<File?> takePhotoWithCamera(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aucune photo prise')),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la prise de photo : $e')),
      );
      return null;
    }
  }
}