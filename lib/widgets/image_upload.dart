import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload(
      {super.key, required this.onSelectImage, this.initialImageBytes});

  // final Function onSelectImage;

  // final Function forClearImage;

  // final void Function(Function) forClearImage;

  final void Function(Uint8List?, TextEditingController, Function)
      onSelectImage;

  final Uint8List? initialImageBytes;

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final TextEditingController imageController = TextEditingController();
  String? pickedFilePath;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    if (widget.initialImageBytes != null) {
      setState(() {
        _imageBytes = widget.initialImageBytes;
      });
    }
  }

  clearImage() {
    setState(() {
      _imageBytes = null;
    });
  }

  // @override
  // void initState() {
  //    super.initState();
  // }

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
    try {
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

      widget.onSelectImage(_imageBytes, imageController, clearImage);
      //  widget.forClearImage(clearImage);
    } on Exception catch (e) {
      // Handle permission errors or other platform exceptions
      if (mounted) {
        print('Error picking image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error accessing gallery. Please check permissions.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              _imageBytes != null
                  ? Image.memory(
                      _imageBytes!,
                      width: 130,
                      height: 130,
                      fit: BoxFit.fill,
                    )
                  : Text('Profile Pic'),
              _imageBytes != null
                  ? Positioned(
                      right: 0.0,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        // onPressed: () => setState(() => _imageBytes = null),
                        onPressed: () {
                          setState(() {
                            _imageBytes = null;
                          });
                        },
                      ),
                    )
                  : SizedBox(),
            ],
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
      ],
    );
  }
}
