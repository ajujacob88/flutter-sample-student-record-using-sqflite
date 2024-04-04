import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final TextEditingController imageController = TextEditingController();
  String? pickedFilePath;
  Uint8List? _imageBytes;

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select image source'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
              child: const Text('Take Photo'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.gallery);
              },
              child: const Text('Choose from Gallery'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    // if (pickedFile != null) {
    //   setState(() {
    //     imageController.text = pickedFile.path;
    //     pickedFilePath = pickedFile.path;
    //   });
    // }

    if (pickedFile != null) {
      final fileBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = Uint8List.fromList(fileBytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Expanded(
        //   child: TextFormField(
        //     readOnly: true,
        //     controller: imageController,
        //     enabled: false,
        //     decoration: const InputDecoration(
        //       labelText: 'Profile Pic',
        //     ),
        //   ),
        // ),
        Expanded(
          child: TextFormField(
            readOnly: true,
            controller: imageController,
            enabled: false,
            decoration: InputDecoration(
              labelText: 'Profile Pic',
              border: InputBorder.none,
              // suffixIcon: pickedFilePath != null
              //     ? SizedBox(
              //         width: 350,
              //         height: 100,
              //         child: Image.file(File(pickedFilePath!)),
              //       )
              //     : null,

              suffixIcon: _imageBytes != null
                  ? Image.memory(
                      _imageBytes!,
                      width: 130,
                      height: 130,
                      fit: BoxFit.fill,
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: OutlinedButton(
            onPressed: _showImageSourceDialog,
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Set the border radius here
                ),
              ),
              side: const MaterialStatePropertyAll(
                BorderSide(color: Color.fromARGB(255, 180, 177, 177)),
              ),
              foregroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 125, 124, 124)),
            ),
            child: const Text('Upload'),
          ),
        ),
        // Expanded(
        //   child: ElevatedButton(
        //     onPressed: _uploadImage,
        //     child: const Text('Upload'),
        //   ),
        // ),
      ],
    );
  }
}