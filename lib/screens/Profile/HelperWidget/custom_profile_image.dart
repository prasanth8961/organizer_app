import 'package:flutter/material.dart';
import 'package:organizer_app/Model/user_model.dart';
import 'package:organizer_app/Provider/image_picker_provider.dart';
import 'package:provider/provider.dart';

class CustomeProfileImageWidget extends StatelessWidget {
  const CustomeProfileImageWidget({
    super.key,
    required this.photoUrl,
    required this.user,
  });

  final String photoUrl;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final imageFile =
        Provider.of<ImagePickerProvider>(context, listen: true).profileImage;
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
              radius: 50,
              backgroundImage: (imageFile != null)
                  ? FileImage(imageFile)
                  : NetworkImage(photoUrl)),
          if (user.verifiedStatus != "pending")
            const Positioned(
              top: 4,
              right: 0,
              child: Icon(Icons.verified, color: Colors.green, size: 25),
            ),
          Positioned(
            bottom: -10,
            right: -6,
            child: IconButton(
              onPressed: () {
                Provider.of<ImagePickerProvider>(context, listen: false)
                    .pickProfileImage();
              },
              icon: Icon(Icons.camera_alt,
                  color: Colors.black.withOpacity(0.5), size: 25),
            ),
          ),
        ],
      ),
    );
  }
}
