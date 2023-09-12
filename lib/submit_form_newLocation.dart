
import 'package:flutter/material.dart';
import 'package:Fixed_Point_Adherence/main.dart';
import 'package:Fixed_Point_Adherence/models/zone_details.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';

DatabaseHelper databaseHelper = DatabaseHelper();


class NewLocationDetailsSubmitForm extends StatelessWidget {
  const NewLocationDetailsSubmitForm({super.key, required this.newLocationDetails});

  final NewLocationDetails newLocationDetails;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // title bar
      appBar: AppBar(

        title: const Text("Submit New Location Data"),
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

              title: Text(newLocationDetails.plantName,
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

              title: Text(newLocationDetails.zoneName,
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

              title: Text(newLocationDetails.zoneLeader,
                style: const TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),

            ),

            SizedBox(height: 40.0,),


            // Save details button -> save to db
            Align(
              child: SizedBox(

                height: 50,
                width: 150,

                child: ElevatedButton(

                  onPressed: () async {

                    try {
                      await databaseHelper.insertRecordPlants(newLocationDetails.plantName);
                      await databaseHelper.insertRecordZones(newLocationDetails.zoneName, newLocationDetails.zoneLeader, newLocationDetails.plantName);

                      await Fluttertoast.showToast(
                        msg: 'Stored the details in the database!',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                      );

                    } catch(e) {
                      await Fluttertoast.showToast(
                        msg: 'Error occurred storing data into the database! Please contact administrator!',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }


                    // go back to previous page after saving
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {

                      return const AdminPage();

                    }), (Route<dynamic> route) => false,);

                  },
                  child: const Text(
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