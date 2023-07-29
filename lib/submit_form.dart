import 'package:flutter/material.dart';
import 'package:path_validation/models/zone_details.dart';

class ZoneDetailsSubmitForm extends StatelessWidget {
  const ZoneDetailsSubmitForm({super.key, required this.zoneDetails});

  final ZoneDetails zoneDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // title bar
      appBar: AppBar(

        title: const Text("Submit Zone Data"),
        centerTitle: true,

        leading: IconButton(

          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),

        ),

      ),

      body: Container(

        padding: const EdgeInsets.all(20.0),

        child: ListView(

          children: [

            // show plant name
            ListTile(

              tileColor: Colors.deepPurple.shade50,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),

              leading: const Icon(

                Icons.factory_rounded,
                color: Colors.deepPurple,

              ),

              title: Text(zoneDetails.plantName,
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),

            ),

            SizedBox(height: 15.0,),

            // show date picked
            ListTile(

              tileColor: Colors.deepPurple.shade50,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),

              leading: const Icon(

                Icons.calendar_month_rounded,
                color: Colors.deepPurple,

              ),

              title: Text(zoneDetails.datePicked,
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),

            ),

            SizedBox(height: 15.0,),

            // show zone name
            ListTile(

              tileColor: Colors.deepPurple.shade50,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),

              leading: const Icon(

                Icons.room_rounded,
                color: Colors.deepPurple,

              ),

              title: Text(zoneDetails.zoneName,
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),

            ),

            SizedBox(height: 15.0,),

            // show zone leader
            ListTile(

              tileColor: Colors.deepPurple.shade50,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),

              leading: const Icon(

                Icons.person,
                color: Colors.deepPurple,

              ),

              title: Text(zoneDetails.zoneLeader,
                style: const TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),

            ),

            SizedBox(height: 15.0,),

            // show path type
            ListTile(

              tileColor: (zoneDetails.pathType != 'OK') 
              ? Colors.red.shade200 : Colors.green.shade200,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),

              leading: const Icon(

                Icons.production_quantity_limits_rounded,
                color: Colors.deepPurple,

              ),

              title: Text(zoneDetails.pathType,
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),

            ),

            SizedBox(height: 15.0,),

            // show image preview
            ListTile(

              tileColor: Colors.deepPurple.shade50,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),

              leading: const Icon(

                Icons.image_rounded,
                color: Colors.deepPurple,

              ),

              title: Image.file(zoneDetails.image, width: 150, height: 250, fit: BoxFit.contain,),

            ),

            SizedBox(height: 40.0,),


            // Save details button -> save to excel
            Align(
              child: SizedBox(

                height: 50,
                width: 150,

                child: ElevatedButton(
                  
                  onPressed: () {}, 
                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                          
                ),
              ),
            ),

          ],

        ),

      ),

    );
  }
}