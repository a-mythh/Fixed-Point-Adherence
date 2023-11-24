import 'package:Fixed_Point_Adherence/models/plant_zone.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// models
import 'package:Fixed_Point_Adherence/models/zone_details.dart';

// submit form
import 'package:Fixed_Point_Adherence/submit_form.dart';

// database and excel
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:Fixed_Point_Adherence/helpers/save_to_excel.dart';

DatabaseHelper databaseHelper = DatabaseHelper();
ExcelHelper excelHelper = ExcelHelper();

enum PathTypeEnum { Path_is_ok, Path_is_not_ok }

class DataEntryForm extends StatefulWidget {
  const DataEntryForm({super.key});

  @override
  State<DataEntryForm> createState() => _DataEntryFormState();
}

class _DataEntryFormState extends State<DataEntryForm> {
  // constructor of the form class
  _DataEntryFormState() {
    _selected_plant = "";
    _selected_zone = "";
  }

  // initialize the state variables
  @override
  void initState() {
    _date_picked_Controller.text = "";
    super.initState();
    _loadPlants();
    _loadZones();
  }

  List<Plant> plants = [];
  List<Zone> zones = [];
  Plant _selectedPlant = Plant(id: 0, plantName: 'None');
  Zone _selectedZone = Zone(id: 0, zoneName: 'None', plantId: 0);
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
  Future<void> _loadZones() async {
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

  // function to open date picker
  Future _select_date() async {
    DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime.now());

    if (datePicked != null) {
      setState(() {
        _date_picked_Controller.text =
            DateFormat('dd-MM-yyyy').format(datePicked);
      });
    }
  }

  File? _image;

  // function to pick image from camera
  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        _image = imageTemp;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  final List<String> plantList = [
    'Avadi',
    'Anna Nagar',
    'Tambaram',
    'Kelambakkam',
    'Shillong'
  ];
  final List<String> zoneList = [
    'Zone 1',
    'Zone 2',
    'Zone 3',
    'Zone 4',
    'Zone 5'
  ];

  // declare controllers here
  final TextEditingController _date_picked_Controller = TextEditingController();
  final TextEditingController _zone_leader_Controller = TextEditingController();

  String? _selected_plant = "";
  String? _selected_zone = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          const SizedBox(
            height: 50,
            width: 50,
            child: Image(
              image: AssetImage('images/wipro_logo.png'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Zone Data Entry",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Roboto",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 59, 57, 57),
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          /* Form for data entry */
          Form(
              key: _formKey,
              child: Column(
                children: [
                  // select plant
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Select Plant',
                      prefixIcon: Icon(
                        Icons.factory_rounded,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),

                    // value: _selectedPlant,
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

                  const SizedBox(height: 40),

                  // select date
                  TextFormField(
                    controller: _date_picked_Controller,
                    readOnly: true,
                    onTap: () => _select_date(),
                    decoration: const InputDecoration(
                      labelText: "Select Date",
                      prefixIcon: Icon(Icons.calendar_month_rounded,
                          color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // select zone
                  DropdownButtonFormField<Zone>(
                    decoration: const InputDecoration(
                      labelText: 'Select Zone',
                      prefixIcon: Icon(
                        Icons.room_rounded,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    value: zones.isNotEmpty ? zones.first : null,
                    items: zones.isEmpty
                        ? null
                        : zones
                            .map(
                              (zone) => DropdownMenuItem(
                                value: zone,
                                child: Text(zone.zoneName),
                              ),
                            )
                            .toList(), //_zoneList

                    onChanged: (zone) {
                      setState(() {
                        _selectedZone = zone!;
                      });
                    },
                  ),

                  const SizedBox(height: 40),

                  // select zone leader
                  TextFormField(
                    controller: _zone_leader_Controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter Zone Leader',
                      prefixIcon: Icon(Icons.person, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // button for clicking picture
                  Align(
                    child: SizedBox(
                      width: 170,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: getImage,
                        child: _image == null
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Click Picture'),
                                ],
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Click Again'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.replay_rounded,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // buttons for ok and not ok
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // OK button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          backgroundColor:
                              const Color.fromARGB(255, 71, 221, 76),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(100, 50),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ZoneDetails zoneDetails = ZoneDetails();

                            zoneDetails.plantName = _selectedPlant.plantName;
                            zoneDetails.datePicked =
                                _date_picked_Controller.text;
                            zoneDetails.zoneName = _selectedZone.zoneName;
                            zoneDetails.zoneLeader =
                                _zone_leader_Controller.text;
                            zoneDetails.pathType = "OK";
                            zoneDetails.image = _image!;

                            // Go to submit page
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              // return Details(zoneDetails: zoneDetails);
                              return ZoneDetailsSubmitForm(
                                zoneDetails: zoneDetails,
                              );
                            }));
                          }
                        },
                        child: const Text("OK"),
                      ),

                      const SizedBox(width: 50),

                      // Not OK Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(100, 50),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ZoneDetails zoneDetails = ZoneDetails();

                            zoneDetails.plantName = _selectedPlant.plantName;
                            zoneDetails.datePicked =
                                _date_picked_Controller.text;
                            zoneDetails.zoneName = _selectedZone.zoneName;
                            zoneDetails.zoneLeader =
                                _zone_leader_Controller.text;
                            zoneDetails.pathType = "Not OK";
                            zoneDetails.image = _image!;

                            // Go to submit page
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ZoneDetailsSubmitForm(
                                zoneDetails: zoneDetails,
                              );
                            }));
                          }
                        },
                        child: const Text("Not OK"),
                      ),
                    ],
                  )
                ],
              )),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
