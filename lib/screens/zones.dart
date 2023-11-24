import 'package:Fixed_Point_Adherence/screens/add_zones.dart';
import 'package:Fixed_Point_Adherence/screens/delete_zones.dart';
import 'package:flutter/material.dart';

class ZoneScreen extends StatelessWidget {
  const ZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zones Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade200,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // add new plant
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddZonesScreen(),
                ));
              },
              borderRadius: BorderRadius.circular(15),
              splashColor: Theme.of(context).primaryColor,
              child: Container(
                  height: 100,
                  width: 150,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.withOpacity(0.4),
                        Colors.green.withOpacity(0.9)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      Text('Add New Zone'),
                    ],
                  )),
            ),

            const SizedBox(height: 40),

            // delete plant
            InkWell(
              onTap: () {
                // delete plant navigator
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const DeleteZonesScreen(),
                ));
              },
              borderRadius: BorderRadius.circular(15),
              splashColor: Theme.of(context).primaryColor,
              child: Container(
                height: 100,
                width: 150,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withOpacity(0.4),
                      Colors.red.withOpacity(0.9)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_forever_rounded),
                    Text('Delete Zone'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
