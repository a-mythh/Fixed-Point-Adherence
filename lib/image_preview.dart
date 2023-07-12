import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class ImagePreview extends StatefulWidget {
  const ImagePreview(this.file, {super.key});

  final XFile file;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    File picture = File(widget.file.path);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Preview'),
      ),
      body: Image.file(picture),
    );
  }
}
