class Plant {

  Plant({required this.id, required this.plantName});

  int id;
  String plantName;

}

class Zone {

  Zone({required this.id, required this.zoneName, required this.plantId});

  int id;
  String zoneName;
  int plantId;

}