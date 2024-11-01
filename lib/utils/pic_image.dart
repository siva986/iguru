// /lib/widgets/pic_image.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Function to show bottom sheet
Future<void> showimagePicker(BuildContext context, Function(XFile?) onImageSelected) async {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(20),
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Select Image Source",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    _pickImage(context, ImageSource.camera).then((value) {
                      onImageSelected(value);
                    });
                  },
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 50,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _pickImage(context, ImageSource.gallery).then((value) {
                      onImageSelected(value);
                    });
                  },
                  icon: const Icon(
                    Icons.photo_library,
                    size: 50,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

// Function to pick image from selected source
Future<XFile?> _pickImage(BuildContext context, ImageSource source) async {
  return ImagePicker().pickImage(source: source).then((value) {
    Navigator.of(context).pop(); // Close the modal after selection
    return value;
  });
}
