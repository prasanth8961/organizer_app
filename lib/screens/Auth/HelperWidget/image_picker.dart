import 'package:flutter/material.dart';
import 'package:organizer_app/Provider/image_picker_provider.dart';
import 'package:provider/provider.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({
    super.key,
    required this.filePickerProvider,
  });

  final ImagePickerProvider filePickerProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload ID Images (Max 2)",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(
            2,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Consumer<ImagePickerProvider>(
                builder: (context, provider, child) {
                  final image = provider.images.length > index
                      ? provider.images[index]
                      : null;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: () => provider.pickImage(),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            image: image != null
                                ? DecorationImage(
                                    image: FileImage(image),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: image == null
                              ? Center(
                                  child: Icon(Icons.add_a_photo,
                                      color: Colors.grey[600]),
                                )
                              : null,
                        ),
                      ),
                      if (image != null)
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {
                              provider
                                  .deleteImage(provider.images.indexOf(image));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.remove_circle,
                                color: Color.fromARGB(255, 244, 58, 58),
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
