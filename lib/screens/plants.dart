import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:Fixed_Point_Adherence/screens/add_plants.dart';
import 'package:Fixed_Point_Adherence/screens/delete_plants.dart';
import 'package:flutter/material.dart';

DatabaseHelper databaseHelper = DatabaseHelper();

class PlantScreen extends StatefulWidget {
  PlantScreen({super.key});

  @override
  State<PlantScreen> createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  @override
  void initState() {
    getPlantCount();
    super.initState();
  }

  int numPlants = 0;

  void getPlantCount() async {
    int count = await databaseHelper.countPlants();
    setState(() {
      numPlants = count;
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
                  numPlants.toString(),
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
                            TextSpan(text: 'PLANTS\n'),
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
                    builder: (context) => const AddPlantsScreen(),
                  ));

                  getPlantCount();
                },
                borderRadius: BorderRadius.circular(15),
                splashColor: Theme.of(context).primaryColor,
                child: Container(
                    height: 100,
                    width: 170,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.77),
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
                          'Add New Plant',
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
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DeletePlantsScreen(),
                  ));
                  getPlantCount();
                },
                borderRadius: BorderRadius.circular(15),
                splashColor: Theme.of(context).primaryColor,
                child: Container(
                  height: 100,
                  width: 170,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.79),
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
                        'Delete Plant',
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
