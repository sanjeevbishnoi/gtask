// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerW extends StatefulWidget {
  final Function(Uint8List) onFileSelected;
  const ImagePickerW({
    Key? key,
    required this.onFileSelected,
  }) : super(key: key);

  @override
  State<ImagePickerW> createState() => _ImagePickerWState();
}

class _ImagePickerWState extends State<ImagePickerW> {
  Uint8List? _file;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _selectImage(context, (Uint8List fileSelected) {
          widget.onFileSelected(fileSelected);
          setState(() {
            _file = fileSelected;
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CircleAvatar(
          radius: 32,
          backgroundImage: _file == null ? null : MemoryImage(_file!),
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _selectImage(
      BuildContext parentContext, Function(Uint8List) onFileSelected) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  onFileSelected(file);
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  onFileSelected(file);
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
  }
}
