import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:Fixed_Point_Adherence/screens/add_zones.dart';
import 'package:Fixed_Point_Adherence/screens/delete_zones.dart';
import 'package:flutter/material.dart';

DatabaseHelper databaseHelper = DatabaseHelper();

class ZoneScreen extends StatefulWidget {
  const ZoneScreen({super.key});

  @override
  State<ZoneScreen> createState() => _ZoneScreenState();
}

class _ZoneScreenState extends State<ZoneScreen> {
  @override
  void initState() {
    getZonesCount();
    super.initState();
  }

  int numZones = 0;

  void getZonesCount() async {
    int count = await databaseHelper.countZones();
    setState(() {
      numZones = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  numZones.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 72),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.outline),
                          children: const [
                            TextSpan(text: 'ZONES\n'),
                            TextSpan(text: 'ARE\n'),
                            TextSpan(text: 'AVAILABLE'),
                          ]),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 150),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // add new plant
              InkWell(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddZonesScreen(),
                  ));

                  getZonesCount();
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
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.85),
                          Colors.black.withOpacity(1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Add Zone',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    )),
              ),

              const SizedBox(width: 20),

              // delete plant
              InkWell(
                onTap: () async {
                  // delete plant navigator
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DeleteZonesScreen(),
                  ));

                  getZonesCount();
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
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.85),
                        Colors.black.withOpacity(1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Delete Zone',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
