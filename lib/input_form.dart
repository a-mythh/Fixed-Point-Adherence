import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_validation/camera_page.dart';

class InputForm extends StatelessWidget {
  const InputForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            color: const Color.fromARGB(255, 148, 215, 246),
            constraints: const BoxConstraints(maxHeight: 100, maxWidth: 300),
            child: Column(
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        const Radio(
                          value: 'Zone 1',
                          groupValue: null,
                          onChanged: null,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Zone 1'),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 50),
                    ),
                    Row(
                      children: [
                        const Radio(
                          value: 'Zone 2',
                          groupValue: null,
                          onChanged: null,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Zone 2'),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        const Radio(
                          value: 'Zone 3',
                          groupValue: null,
                          onChanged: null,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Zone 3'),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 50),
                    ),
                    Row(
                      children: [
                        const Radio(
                          value: 'Zone 4',
                          groupValue: null,
                          onChanged: null,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Zone 4'),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
          ),
          ElevatedButton(
            onPressed: () async {
              await availableCameras().then(
                (value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraPage(
                      cameras: value,
                    ),
                  ),
                ),
              );
            },
            child: const Text('Click Picture'),
          )
        ],
      );
  }
}