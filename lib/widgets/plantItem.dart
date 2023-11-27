import 'package:Fixed_Point_Adherence/models/plant_zone.dart';
import 'package:flutter/material.dart';

class PlantItem extends StatelessWidget {
  const PlantItem({required this.plant, required this.deletePlant, super.key});

  final Plant plant;
  final Function deletePlant;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25)
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                plant.plantName,
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
                              text: plant.plantName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                            const TextSpan(text: ' plant.')
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

                deletePlant(plant);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
