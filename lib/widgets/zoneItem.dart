import 'package:Fixed_Point_Adherence/models/plant_zone.dart';
import 'package:flutter/material.dart';

class ZoneItem extends StatelessWidget {
  const ZoneItem({required this.zone, required this.deleteZone, super.key});

  final Zone zone;
  final Function deleteZone;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25)
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                zone.zoneName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            IconButton(
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                    title: const Text('Are you sure?',
                        textAlign: TextAlign.center),
                    content: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            const TextSpan(
                                text: 'This action will permanently delete '),
                            TextSpan(
                              text: zone.zoneName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const TextSpan(text: ' zone.')
                          ]),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          'Delete',
                          style: Theme.of(context).textTheme.bodyLarge!.
                          copyWith(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                if (result == null || !result) {
                  return;
                }

                deleteZone(zone);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
