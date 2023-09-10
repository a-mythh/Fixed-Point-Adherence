import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

DatabaseHelper databaseHelper = DatabaseHelper();

// Excel Functionality
class ExcelHelper {
  static final ExcelHelper _instance = ExcelHelper.internal();
  factory ExcelHelper() => _instance;

  ExcelHelper.internal();

  Future<String?> _getExcelDirectory() async {
  try {

    final excelDirectory = Directory('/storage/emulated/0/Documents/');

    if (!await excelDirectory.exists()) {
      await excelDirectory.create(recursive: true);
    }

    return excelDirectory.path;
  } catch (e) {
    print('Error while getting or creating directory: $e');
    return null;
  }
}

Future<Uint8List> imgDecode(String encodedImage) async {
  //decode the image back to binary for image conversion
  final Uint8List uint8List = base64Decode(encodedImage);
  return uint8List;
}


  Future<void> saveToExcel() async {

    Future<List<Map<String, dynamic>>?> data = DatabaseHelper().getRecordsData();

    final excelDirectory = await _getExcelDirectory();
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
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    }
    final excelFilePath = path.join(excelDirectory, 'zone_data.xlsx');

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

// Create or open the workbook
    final Workbook workbook = Workbook();
    final sheetName = 'Date_${DateFormat('dd-MMMM-yyyy').format(DateTime.now())}';
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

    // Add headers
    sheet.getRangeByName('A1').setText(' Date ');
    sheet.getRangeByName('B1').setText('Plant Name');
    sheet.getRangeByName('C1').setText('Zone Name');
    sheet.getRangeByName('D1').setText('Zone Leader');
    sheet.getRangeByName('E1').setText(' OK/NOT OK ');
    sheet.getRangeByName('F1').setText('Image');

    //Style the headers
    Style headerStyle = workbook.styles.add('header_style');
//set back color by hexa decimal.
    headerStyle.backColor = '#ffffff';
//set font name.
    headerStyle.fontName = 'Roboto';
//set font size.
    headerStyle.fontSize = 15;
//set font color by hexa decimal.
    headerStyle.fontColor = '#000000';
//set font bold.
    headerStyle.bold = true;
//set horizontal alignment type.
    headerStyle.hAlign = HAlignType.center;
//set vertical alignment type.
    headerStyle.vAlign = VAlignType.center;
    //set all border line style.
    headerStyle.borders.all.lineStyle = LineStyle.thick;
//set border color by hexa decimal.
    headerStyle.borders.all.color = '#000000';

    Style cellStyleOk = workbook.styles.add('header_style_ok');
    cellStyleOk.backColor = "#15ff00";
    cellStyleOk.fontColor = "#000000";
    cellStyleOk.bold = true;
    cellStyleOk.hAlign = HAlignType.center;
    cellStyleOk.vAlign = VAlignType.center;
    cellStyleOk.borders.all.lineStyle = LineStyle.thin;
    cellStyleOk.borders.all.color = '#000000';

    Style cellStyleNotOk = workbook.styles.add('header_style_notok');
    cellStyleNotOk.backColor = "#ff0000";
    cellStyleNotOk.fontColor = "#000000";
    cellStyleNotOk.bold = true;
    cellStyleNotOk.hAlign = HAlignType.center;
    cellStyleNotOk.vAlign = VAlignType.center;
    cellStyleNotOk.borders.all.lineStyle = LineStyle.thin;
    cellStyleNotOk.borders.all.color = '#000000';

    sheet.getRangeByName('A1:F1').cellStyle = headerStyle;
    sheet.getRangeByName('A1:F1').rowHeight = 100;
    sheet.getRangeByName('A1').columnWidth = 80;
    sheet.getRangeByName('B1').columnWidth = 80;
    sheet.getRangeByName('C1').columnWidth = 80;
    sheet.getRangeByName('D1').columnWidth = 80;
    sheet.getRangeByName('E1').columnWidth = 80;
    sheet.getRangeByName('F1').columnWidth = 50;

    //style the cells
    Style cellStyle = workbook.styles.add('cell_style');
//set font bold.
    cellStyle.bold = true;
//set horizontal alignment type.
    cellStyle.hAlign = HAlignType.center;
//set vertical alignment type.
    cellStyle.vAlign = VAlignType.center;
    cellStyle.borders.all.lineStyle = LineStyle.thin;
    cellStyle.borders.all.color = '#000000';

    // Write the form data to the Excel sheet

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

    if(fetchedData != null) {
      for (var row in fetchedData) {
        final int excelRow = sheet.getLastRow() + 1;

        sheet.getRangeByName('A$excelRow:F$excelRow').cellStyle = cellStyle;

        sheet.getRangeByName('A$excelRow').setText(row['datePicked']);
        sheet.getRangeByName('A$excelRow').rowHeight = 220;

        sheet.getRangeByName('B$excelRow').setText(row['plantName']);

        sheet.getRangeByName('C$excelRow').setText(row['zoneName']);

        sheet.getRangeByName('D$excelRow').setText(row['zoneLeader']);

        sheet.getRangeByName('E$excelRow').setText(row['pathType']);


        if(row['pathType'] == "OK") {
          sheet.getRangeByName('E$excelRow').cellStyle = cellStyleOk;
        }

        else {
          sheet.getRangeByName('E$excelRow').cellStyle = cellStyleNotOk;
        }


        // Convert the image to bytes then to picture to paste it into excel

        if(row['imagePath'] != null) {
          final File imageFile = File(row['imagePath']);
          Uint8List imageBytes = await imageFile.readAsBytes();
          // Add the image bytes to the worksheet
          final Picture picture = sheet.pictures.addStream(excelRow, sheet.getLastColumn(), imageBytes);
          picture.height = 294;
          picture.width = 294;
          picture.rotation = 90;
        }

      }
    }

    final Range range = sheet.getRangeByName('A1:F1');
    // Auto-Fit column the range
    range.autoFitColumns();

    // Save the Excel file
    final List<int> bytes = workbook.saveAsStream();
    final file = File(excelFilePath);
    await file.writeAsBytes(bytes, mode: FileMode.write);

    // Close the workbook
    workbook.dispose();

    // Show a success toast message
    Fluttertoast.showToast(
      msg: "Excel saved to Documents folder!", //Data successfully saved to Excel successfully!
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

}