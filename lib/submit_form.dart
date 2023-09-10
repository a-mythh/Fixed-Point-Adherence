import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:Fixed_Point_Adherence/main.dart';
import 'package:Fixed_Point_Adherence/models/zone_details.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:typed_data';
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';

DatabaseHelper databaseHelper = DatabaseHelper();


class ZoneDetailsSubmitForm extends StatelessWidget {
  const ZoneDetailsSubmitForm({super.key, required this.zoneDetails});

  final ZoneDetails zoneDetails;

  // change the image name
  Future<File> changeFileNameOnly(File file, String newFileName) {

    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.rename(newPath);

  }

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

                  onPressed: () async {

                    try {

                      String dir = path.dirname(zoneDetails.image.path);
                      String newName = path.join(dir, '${zoneDetails.pathType}__${zoneDetails.zoneName}__${zoneDetails.datePicked}.jpg');
                      File(zoneDetails.image.path).rename(newName).then((renamedFile) async {


                        // Perform the image renaming asynchronously

                        try {
                          await GallerySaver.saveImage(newName, albumName: 'Fixed Point Adherence')
                              .then((success) async {


                                try {
                                  await databaseHelper.insertRecordData(zoneDetails.datePicked, zoneDetails.plantName, zoneDetails.zoneName, zoneDetails.zoneLeader, zoneDetails.pathType, newName);

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

                              return const HomePage();

                            }), (Route<dynamic> route) => false,);

                            if (success != null && success == true) {
                              const snackBar = SnackBar(content: Text('Saved the image!'),);

                              await ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }

                          });
                        } catch (e) {
                          // Show an error snackbar if saving to gallery fails

                          const snackBar = SnackBar(content: Text('Error while saving the image.'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });

                    }
                    catch (e) {
                      log('Error while saving $e');
                    }

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