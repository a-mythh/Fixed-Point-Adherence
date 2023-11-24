import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

DatabaseHelper databaseHelper = DatabaseHelper();

Map<String, dynamic> stylingSheet(Workbook workbook, Worksheet sheet) 
{
  // Add column names
  sheet.getRangeByName('A1').setText('Date');
  sheet.getRangeByName('B1').setText('Plant Name');
  sheet.getRangeByName('C1').setText('Zone Name');
  sheet.getRangeByName('D1').setText('Zone Leader');
  sheet.getRangeByName('E1').setText('Path Status');
  sheet.getRangeByName('F1').setText('Image');

  /****  Column style  *****/
  Style headerStyle = workbook.styles.add('header_style');
  headerStyle.backColor = '#ffffff'; // background colour
  headerStyle.fontName = 'Roboto'; // font
  headerStyle.fontSize = 15; // font size
  headerStyle.fontColor = '#000000'; // text colour
  headerStyle.bold = true; // font weight
  headerStyle.hAlign = HAlignType.center; // horizontal alignment
  headerStyle.vAlign = VAlignType.center; // vertical alignment
  headerStyle.borders.all.lineStyle = LineStyle.thick; // border
  headerStyle.borders.all.color = '#000000'; // border colour

  /**** Cell style for Path = OK ****/
  Style cellStyleOk = workbook.styles.add('header_style_ok');
  cellStyleOk.backColor = "#15ff00";
  cellStyleOk.fontColor = "#000000";
  cellStyleOk.bold = true;
  cellStyleOk.hAlign = HAlignType.center;
  cellStyleOk.vAlign = VAlignType.center;
  cellStyleOk.borders.all.lineStyle = LineStyle.thin;
  cellStyleOk.borders.all.color = '#000000';

  /**** Cell style for Path = OK ****/
  Style cellStyleNotOk = workbook.styles.add('header_style_notok');
  cellStyleNotOk.backColor = "#ff0000";
  cellStyleNotOk.fontColor = "#000000";
  cellStyleNotOk.bold = true;
  cellStyleNotOk.hAlign = HAlignType.center;
  cellStyleNotOk.vAlign = VAlignType.center;
  cellStyleNotOk.borders.all.lineStyle = LineStyle.thin;
  cellStyleNotOk.borders.all.color = '#000000';

  /**** Resize the rows and columns ****/
  sheet.getRangeByName('A1:F1').cellStyle = headerStyle;
  sheet.getRangeByName('A1:F1').rowHeight = 100;
  sheet.getRangeByName('A1').columnWidth = 100;
  sheet.getRangeByName('B1').columnWidth = 80;
  sheet.getRangeByName('C1').columnWidth = 80;
  sheet.getRangeByName('D1').columnWidth = 80;
  sheet.getRangeByName('E1').columnWidth = 80;
  sheet.getRangeByName('F1').columnWidth = 50;

  /**** Cell style ****/
  Style cellStyle = workbook.styles.add('cell_style');
  cellStyle.bold = true;
  cellStyle.hAlign = HAlignType.center;
  cellStyle.vAlign = VAlignType.center;
  cellStyle.borders.all.lineStyle = LineStyle.thin;
  cellStyle.borders.all.color = '#000000';

  return {
    'cell style': cellStyle,
    'cell style OK': cellStyleOk,
    'cell style Not OK': cellStyleNotOk
  };
}

void addDataIntoSheet(
  Worksheet sheet,
  Map<String, dynamic> cellStyles,
  Map<String, dynamic> row,
) 
{
  Style cellStyle = cellStyles['cell style'];
  Style cellStyleOk = cellStyles['cell style OK'];
  Style cellStyleNotOk = cellStyles['cell style Not OK'];

  final int excelRow = sheet.getLastRow() + 1;

  sheet.getRangeByName('A$excelRow:F$excelRow').cellStyle = cellStyle;
  sheet.getRangeByName('A$excelRow').rowHeight = 220;

  sheet.getRangeByName('A$excelRow').setText(row['date']);
  sheet.getRangeByName('B$excelRow').setText(row['plant']);
  sheet.getRangeByName('C$excelRow').setText(row['zone']);
  sheet.getRangeByName('D$excelRow').setText(row['zone leader']);
  sheet.getRangeByName('E$excelRow').setText(row['path status']);
  if (row['path status'] == "OK") {
    sheet.getRangeByName('E$excelRow').cellStyle = cellStyleOk;
  } else {
    sheet.getRangeByName('E$excelRow').cellStyle = cellStyleNotOk;
  }

  final Picture picture = sheet.pictures.addStream(
    excelRow,
    sheet.getLastColumn(),
    row['image'],
  );
  picture.height = 294;
  picture.width = 294;
  picture.rotation = 90;

}

// Excel Functionality
class ExcelHelper 
{
  static final ExcelHelper _instance = ExcelHelper.internal();
  factory ExcelHelper() => _instance;

  ExcelHelper.internal();

  // create excel if it doesn't exist already
  Future<String?> _getExcelDirectory() async {
    try {
      final excelDirectory = Directory('/storage/emulated/0/Documents/Fixed Point Adherence');

      if (!await excelDirectory.exists()) {
        await excelDirectory.create(recursive: true);
      }

      return excelDirectory.path;
    } catch (e) {
      return null;
    }
  }

  //decode the image back to binary for image conversion
  Future<Uint8List> imgDecode(String encodedImage) async {
    final Uint8List uint8List = base64Decode(encodedImage);
    return uint8List;
  }

  Future<void> saveTodaysDataToExcel() async
  {
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

    // retrieve the data
    List<Map<String, dynamic>>? fetchedData = await DatabaseHelper().getRecordsDataByDate(date);
    
    // if data not present
    if (fetchedData == null) {
      Fluttertoast.showToast(
        msg: 'DATA NOT THERE!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }


    /**** Getting permissions and storage location ****/

    // get the location to store the excel file
    final excelDirectory = await _getExcelDirectory();

    // if unable to create excel sheet
    if (excelDirectory == null) {
      Fluttertoast.showToast(
        msg: 'Error retrieving Excel workbook directory!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // get permission to store excel file
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    }
    final excelFilePath = path.join(excelDirectory, '$date.xlsx');
  


    /*** Creating excel and adding a sheet with styles ***/

    // Create or open the workbook
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = date;

    // style the excel sheet
    Map<String, dynamic> cellStyles = stylingSheet(workbook, sheet);

    // add data into the sheet
    for (var row in fetchedData) 
    {
      String datePicked = row['datePicked'];
      String plantName = row['plantName'];
      String zoneName = row['zoneName'];
      String zoneLeader = row['zoneLeader'];
      String pathType = row['pathType'];
      Uint8List? imageBytes;
      if (row['imagePath'] != null) {
        final File imageFile = File(row['imagePath']);
        imageBytes = await imageFile.readAsBytes();
      } else {
        imageBytes = null;
      }

      Map<String, dynamic> outputData = {
        'date': datePicked,
        'plant': plantName,
        'zone': zoneName,
        'zone leader': zoneLeader,
        'path status': pathType,
        'image': imageBytes
      };

      addDataIntoSheet(sheet, cellStyles, outputData);
    }
    


    /*** Save and close the excel ***/

    // Save the Excel file
    final List<int> bytes = workbook.saveAsStream();
    final file = File(excelFilePath);
    await file.writeAsBytes(bytes, mode: FileMode.write);

    // Close the workbook
    workbook.dispose();


    // Show a success toast message
    Fluttertoast.showToast(
      msg: "Excel saved to Documents folder!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  Future<void> saveGivenDatesDataToExcel(String date) async
  {
    // retrieve the data
    List<Map<String, dynamic>>? fetchedData = await DatabaseHelper().getRecordsDataByDate(date);
    
    // if data not present
    if (fetchedData == null) {
      Fluttertoast.showToast(
        msg: 'DATA NOT THERE!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }


    /**** Getting permissions and storage location ****/

    // get the location to store the excel file
    final excelDirectory = await _getExcelDirectory();

    // if unable to create excel sheet
    if (excelDirectory == null) {
      Fluttertoast.showToast(
        msg: 'Error retrieving Excel workbook directory!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // get permission to store excel file
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    }
    final excelFilePath = path.join(excelDirectory, '$date.xlsx');
  


    /*** Creating excel and adding a sheet with styles ***/

    // Create or open the workbook
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = date;

    // style the excel sheet
    Map<String, dynamic> cellStyles = stylingSheet(workbook, sheet);

    // add data into the sheet
    for (var row in fetchedData) 
    {
      String datePicked = row['datePicked'];
      String plantName = row['plantName'];
      String zoneName = row['zoneName'];
      String zoneLeader = row['zoneLeader'];
      String pathType = row['pathType'];
      Uint8List? imageBytes;
      if (row['imagePath'] != null) {
        final File imageFile = File(row['imagePath']);
        imageBytes = await imageFile.readAsBytes();
      } else {
        imageBytes = null;
      }

      Map<String, dynamic> outputData = {
        'date': datePicked,
        'plant': plantName,
        'zone': zoneName,
        'zone leader': zoneLeader,
        'path status': pathType,
        'image': imageBytes
      };

      addDataIntoSheet(sheet, cellStyles, outputData);
    }
    


    /*** Save and close the excel ***/

    // Save the Excel file
    final List<int> bytes = workbook.saveAsStream();
    final file = File(excelFilePath);
    await file.writeAsBytes(bytes, mode: FileMode.write);

    // Close the workbook
    workbook.dispose();


    // Show a success toast message
    Fluttertoast.showToast(
      msg: "Excel saved to Documents folder!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }


  Future<void> saveToExcel() async 
  {
    Future<List<Map<String, dynamic>>?> data = DatabaseHelper().getRecordsData();

    final excelDirectory = await _getExcelDirectory();

    // if unable to create excel sheet
    if (excelDirectory == null) {
      Fluttertoast.showToast(
        msg: 'Error retrieving Excel workbook directory!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // get permission to store excel file
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    }
    final excelFilePath = path.join(excelDirectory, 'zone_data.xlsx');

    /*
    if (excelFilePath == null) {
      Fluttertoast.showToast(
        msg: 'Error retrieving Excel workbook!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return;
    }
    */

    // Create or open the workbook
    final Workbook workbook = Workbook();
    final sheetName =
        'Date_${DateFormat('dd-MM-yyyy').format(DateTime.now())}';
    Worksheet? sheet;

    // Check if the sheet already exists
    for (int i = 0; i < workbook.worksheets.count; i++) {
      final ws = workbook.worksheets[i];
      if (ws.name == sheetName) {
        // Sheet with the desired name already exists, access it
        sheet = ws;
        break;
      }
    }

    // If the sheet does not exist, add a new one
    if (sheet == null) {
      workbook.worksheets.addWithName(sheetName);
      sheet = workbook.worksheets[sheetName];
    }

    // style the excel sheet
    Map<String, dynamic> cellStyles = stylingSheet(workbook, sheet);

    // get the data from the database
    List<Map<String, dynamic>>? fetchedData = await data;
    if (fetchedData == null) {
      Fluttertoast.showToast(
        msg: 'DATA NOT THERE!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    // add data into the sheet
    if (fetchedData != null) {
      for (var row in fetchedData) {
        String datePicked = row['datePicked'];
        String plantName = row['plantName'];
        String zoneName = row['zoneName'];
        String zoneLeader = row['zoneLeader'];
        String pathType = row['pathType'];
        Uint8List? imageBytes;
        if (row['imagePath'] != null) {
          final File imageFile = File(row['imagePath']);
          imageBytes = await imageFile.readAsBytes();
        } else {
          imageBytes = null;
        }

        Map<String, dynamic> outputData = {
          'date': datePicked,
          'plant': plantName,
          'zone': zoneName,
          'zone leader': zoneLeader,
          'path status': pathType,
          'image': imageBytes
        };

        addDataIntoSheet(sheet, cellStyles, outputData);
      }
    }

    // Save the Excel file
    final List<int> bytes = workbook.saveAsStream();
    final file = File(excelFilePath);
    await file.writeAsBytes(bytes, mode: FileMode.write);

    // Close the workbook
    workbook.dispose();

    // Show a success toast message
    Fluttertoast.showToast(
      msg:
          "Excel saved to Documents folder!", //Data successfully saved to Excel successfully!
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }
}
