import 'dart:developer';
import 'dart:io';
import 'package:Fixed_Point_Adherence/screens/data_entry.dart';
import 'package:Fixed_Point_Adherence/utility/CustomSnackbar.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:Fixed_Point_Adherence/models/zone_details.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';

DatabaseHelper databaseHelper = DatabaseHelper();

class ZoneDetailsSubmitScreen extends StatelessWidget {
  const ZoneDetailsSubmitScreen({super.key, required this.zoneDetails});

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
      appBar: AppBar(
        title: const Text("Submit Zone Data"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // show plant name
            ListTile(
              tileColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              leading: const Icon(Icons.factory_rounded),
              title: Text(zoneDetails.plantName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 15),

            // show date picked
            ListTile(
              tileColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              leading: const Icon(Icons.calendar_month_rounded),
              title: Text(zoneDetails.datePicked,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 15),

            // show zone name
            ListTile(
              tileColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              leading: const Icon(Icons.forklift),
              title: Text(zoneDetails.zoneName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 15),

            // show zone leader
            ListTile(
              tileColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              leading: const Icon(Icons.badge_rounded),
              title: Text(zoneDetails.zoneLeader,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 15),

            // show path type
            ListTile(
              trailing: (zoneDetails.pathType == 'OK')
                  ? const Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
              tileColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              leading: const Icon(Icons.paste_rounded),
              title: Text(zoneDetails.pathType,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 15),

            // show image preview
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              tileColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              leading: const Icon(Icons.image_rounded),
              title: Image.file(
                zoneDetails.image,
                width: 150,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              'Please confirm the details before submitting.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontStyle: FontStyle.italic),
            ),

            const SizedBox(height: 20),

            // Save details button -> save to excel
            Align(
              child: SizedBox(
                height: 50,
                width: 120,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primaryContainer)),
                  onPressed: () async {
                    try {
                      String dir = path.dirname(zoneDetails.image.path);
                      String newName = path.join(dir,
                          '${zoneDetails.pathType}__${zoneDetails.zoneName}__${zoneDetails.datePicked}.jpg');
                      File(zoneDetails.image.path)
                          .rename(newName)
                          .then((renamedFile) async {
                        // renaming image
                        try {
                          await GallerySaver.saveImage(newName,
                                  albumName: 'Fixed Point Adherence')
                              .then((success) async {
                            try {
                              await databaseHelper.insertData(
                                  zoneDetails.datePicked,
                                  zoneDetails.plantName,
                                  zoneDetails.zoneName,
                                  zoneDetails.zoneLeader,
                                  zoneDetails.pathType,
                                  newName);

                              final snackBar = showCustomSnackbar(
                                text: 'Saved successfully.',
                                colour: 'success',
                              );
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);

                              // await Fluttertoast.showToast(
                              //   msg: 'Stored the details in the database!',
                              //   toastLength: Toast.LENGTH_LONG,
                              //   gravity: ToastGravity.BOTTOM,
                              //   backgroundColor: Colors.green,
                              //   textColor: Colors.white,
                              // );
                            } catch (e) {
                              final snackBar = showCustomSnackbar(
                                text: 'Error occurred while saving.',
                                colour: 'failure',
                              );
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);

                              // await Fluttertoast.showToast(
                              //   msg:
                              //       'Error occurred storing data into the database! Please contact administrator!',
                              //   toastLength: Toast.LENGTH_LONG,
                              //   gravity: ToastGravity.BOTTOM,
                              //   backgroundColor: Colors.red,
                              //   textColor: Colors.white,
                              // );
                            }

                            // go back to previous page after saving
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const DataEntryScreen();
                              }),
                              (Route<dynamic> route) => false,
                            );

                            // if (success != null && success == true) {
                            //   const snackBar = SnackBar(
                            //     content: Text('Saved the image!'),
                            //   );

                            //   await ScaffoldMessenger.of(context)
                            //       .showSnackBar(snackBar);
                            // }
                          });
                        } catch (e) {
                          // Show an error snackbar if saving to gallery fails

                          final snackBar = showCustomSnackbar(
                            text: 'Error occurred while saving.',
                            colour: 'failure',
                          );
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    } catch (e) {
                      log('Error while saving $e');
                    }
                  },
                  child: Text(
                    "Save",
                    style: Theme.of(context).textTheme.bodyLarge,
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
