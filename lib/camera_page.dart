import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:path_validation/image_preview.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraPage({this.cameras, Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  XFile? pictureFile;

  // for tap to focus
  bool showFocusCircle = false;
  double x = 0;
  double y = 0;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras![0],
      ResolutionPreset.max,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    controller.setFlashMode(FlashMode.off);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return GestureDetector(
      onTapUp: (details) {
        _onTap(details);
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: Container(
                height: 700,
                width: 700,
                margin: const EdgeInsets.only(bottom: 70),
                child: CameraPreview(controller),
              ),
            ),
          ),
          Positioned(
            left:  MediaQuery.of(context).size.width / 2 - 40,
            bottom: 40,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  pictureFile = await controller.takePicture();
          
                  // Preview Picture in another page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImagePreview(pictureFile!),
                    ),
                  );
          
                  setState(() {});
                },
                child: const Text(' '),
              ),
            ),
          ),
          if (showFocusCircle)  
            Positioned(
              top: y - 20,
              left: x - 20,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5)),
              ),
            )
        ],
      ),
    );
  }

  Future<void> _onTap(TapUpDetails details) async {
    if (controller.value.isInitialized) {
      showFocusCircle = true;
      x = details.localPosition.dx;
      y = details.localPosition.dy;

      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = fullWidth * controller.value.aspectRatio;

      double xp = x / fullWidth;
      double yp = y / cameraHeight;

      Offset point = Offset(xp, yp);
      print("point : $point");

      // Manually focus
      await controller.setFocusPoint(point);

      // Manually set light exposure
      controller.setExposurePoint(point);

      setState(() {
        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          setState(() {
            showFocusCircle = false;
          });
        });
      });
    }
  }
}
