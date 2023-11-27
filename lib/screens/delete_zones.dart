import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:Fixed_Point_Adherence/models/plant_zone.dart';
import 'package:Fixed_Point_Adherence/widgets/zoneItem.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

DatabaseHelper databaseHelper = DatabaseHelper();

class DeleteZonesScreen extends StatefulWidget {
  const DeleteZonesScreen({super.key});

  @override
  State<DeleteZonesScreen> createState() => _DeleteZonesScreenState();
}

class _DeleteZonesScreenState extends State<DeleteZonesScreen> {
  @override
  void initState() {
    super.initState();
    _loadPlants();
    _loadZones();
  }

  List<Plant> plants = [];
  List<Zone> zones = [];
  Plant _selectedPlant = Plant(id: 0, plantName: 'None');
  int _selectedPlantId = 0;
  bool _isLoading = true;
  String _error = '';

  // load plants to display
  void _loadPlants() async {
    try {
      final fetchedPlants = await databaseHelper.getPlants();

      // when no data is present in database
      if (fetchedPlants == null) {
        setState(() {
          _isLoading = false;
        });
        return null;
      }

      final List<Plant> loadedPlants = [];

      for (final row in fetchedPlants) {
        int id = row['id'];
        String plantName = row['plantName'];

        Plant plant = Plant(id: id, plantName: plantName);
        loadedPlants.add(plant);
      }

      setState(() {
        plants = loadedPlants;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong. Please try again later!';
        print(error);
      });
    }

    _selectedPlant = plants[0];
  }

  // load zones to display
  void _loadZones() async {
    try {
      final fetchedZones = await databaseHelper.getZones(_selectedPlant);

      // when no data is present in database
      if (fetchedZones == null) {
        setState(() {
          _isLoading = false;
        });
        return null;
      }

      final List<Zone> loadedZones = [];

      for (final row in fetchedZones) {
        int id = row['id'];
        String zoneName = row['zoneName'];
        int plantId = row['plantId'];

        Zone zone = Zone(id: id, zoneName: zoneName, plantId: plantId);
        loadedZones.add(zone);
      }

      setState(() {
        zones = loadedZones;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong. Please try again later!';
        print(error);
      });
    }
  }

  // delete plant
  void _deleteZone(Zone zone) async {
    try {
      await databaseHelper.deleteZone(zone);
      _loadZones();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Delete Zones'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 20,
        ),
        child: Column(
          children: [
            // dropdown menu to select plant
            DropdownButtonFormField<Plant>(
              icon: const Icon(Icons.expand_more_rounded),
              dropdownColor: Theme.of(context).colorScheme.surface,
              decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.surface,
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                prefixIcon: const Icon(Icons.factory_rounded),
                labelText: 'Select Plant',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              borderRadius: BorderRadius.circular(20),
              items: plants
                  .map(
                    (plant) => DropdownMenuItem(
                      value: plant,
                      child: Text(plant.plantName),
                    ),
                  )
                  .toList(),
              onChanged: (plant) {
                setState(() {
                  _selectedPlant = plant!;
                  _selectedPlantId = plant.id;
                  _loadZones();
                });
              },
            ),

            const SizedBox(height: 30),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...zones.map(
                      (zone) => ZoneItem(
                        zone: zone,
                        deleteZone: _deleteZone,
                      ),
                    )
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
