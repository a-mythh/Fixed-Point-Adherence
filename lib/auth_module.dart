import 'package:encrypt/encrypt.dart';
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart' as Material;


DatabaseHelper databaseHelper = DatabaseHelper();

class AuthModule {
  static final key = Key.fromLength(32);
  static final encrypter = Encrypter(AES(key));

  static Future<void> signUp(String username, String password, String accType) async {

    try {
      final encryptedPassword = encrypter.encrypt(password, iv: IV.fromLength(16));
      await databaseHelper.insertRecordUser(username, encryptedPassword.base64, accType).then((value) async=> {
        await Fluttertoast.showToast(
          msg: 'User successfully signed up!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Material.Colors.green,
          textColor: Material.Colors.white,
        )
      });

    } catch(e) {
      await Fluttertoast.showToast(
        msg: 'User registration failed!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Material.Colors.red,
        textColor: Material.Colors.white,
      );

    }
  }

  static Future<Map<String, dynamic>> login(String username, String password) async {

    Map<String, dynamic> result = {'userType': 'user', 'isLogin': true};

    Future<List<Map<String, dynamic>>?> data = DatabaseHelper().getRecordsSingleUser(username);
    List<Map<String, dynamic>>? fetchedData = await data;

    if (fetchedData == null) {
      Fluttertoast.showToast(
        msg: 'Username is not registered!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Material.Colors.red,
        textColor: Material.Colors.white,
      );

      return result;
    }

    var data_row = fetchedData[0];

    final storedPasswordBase64 = data_row['password'];

    final accType = data_row['accType'];

    if (storedPasswordBase64 != null) {
      final storedPassword = Encrypted.fromBase64(storedPasswordBase64);
      final decryptedPassword = encrypter.decrypt(storedPassword, iv: IV.fromLength(16));
      if(password == decryptedPassword) {

          if(accType == 'User') {
                Fluttertoast.showToast(
                  msg: 'Successfully Logged In!',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Material.Colors.green,
                  textColor: Material.Colors.white
                );

                result['isLogin'] = true;

                return result;
          }

        else if(accType == 'Admin') {
                Fluttertoast.showToast(
                  msg: 'Successfully Logged In!',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Material.Colors.green,
                  textColor: Material.Colors.white
                );

                result['isLogin'] = true;
                result['userType'] = 'admin';

                return result;
        }

      }

      else {

        result['isLogin'] = false;
        return result;
      }
    }

    else {
      result['isLogin'] = false;
      return result;
    }


    return result;

  }

  static Future<bool> resetPassword(String username, String password, String newPassword) async {

    Future<List<Map<String, dynamic>>?> data = DatabaseHelper().getRecordsSingleUser(username);
    List<Map<String, dynamic>>? fetchedData = await data;

    if (fetchedData == null) {
      Fluttertoast.showToast(
        msg: 'Username is not registered!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Material.Colors.red,
        textColor: Material.Colors.white,
      );

      return false;
    }

    var data_row = fetchedData[0];

    final storedPasswordBase64 = data_row['password'];

    if (storedPasswordBase64 != null) {
      final storedPassword = Encrypted.fromBase64(storedPasswordBase64);
      final decryptedPassword = encrypter.decrypt(storedPassword, iv: IV.fromLength(16));
      if(newPassword == decryptedPassword) {

        Fluttertoast.showToast(
          msg: 'New password cannot be same as before!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Material.Colors.red,
          textColor: Material.Colors.white,
        );

        return false;
      }

      else {
        try {
          final encryptedPassword = encrypter.encrypt(newPassword, iv: IV.fromLength(16));
          await databaseHelper.updateRecordUserPass(username, encryptedPassword.base64).then((value) async=> {
            await Fluttertoast.showToast(
              msg: 'Password reset successful!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Material.Colors.green,
              textColor: Material.Colors.white,
            )
          });

          return true;

        } catch(e) {
          await Fluttertoast.showToast(
            msg: 'User registration failed!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Material.Colors.red,
            textColor: Material.Colors.white,
          );

          return false;

        }
      }
    }

    return false;
  }
}
