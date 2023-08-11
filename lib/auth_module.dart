import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart' as Material;
import 'package:flutter_dotenv/flutter_dotenv.dart';


DatabaseHelper databaseHelper = DatabaseHelper();

class AuthModule {
  static final key = Key.fromLength(32);
  static final encrypter = Encrypter(AES(key));

  static Future<void> signUp(String username, String password, String secret) async {

    String? secret_ = dotenv.env['SECRET_KEY'];

    if(secret_ != secret) {
      await Fluttertoast.showToast(
        msg: 'Invalid Secret Key!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Material.Colors.red,
        textColor: Material.Colors.white,
      );
    }

    else {
      final encryptedPassword = encrypter.encrypt(password, iv: IV.fromLength(16));

      try {
        await databaseHelper.insertRecordUser(username, encryptedPassword.base64).then((value) async=> {
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
  }

  static Future<bool> login(String username, String password) async {

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

    var data_row = fetchedData?[0];

    final storedPasswordBase64 = data_row?['password'];

    if (storedPasswordBase64 != null) {
      final storedPassword = Encrypted.fromBase64(storedPasswordBase64);
      final decryptedPassword = encrypter.decrypt(storedPassword, iv: IV.fromLength(16));
      if(password == decryptedPassword) {

        Fluttertoast.showToast(
          msg: 'Successfully Logged In!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Material.Colors.green,
          textColor: Material.Colors.white,
        );

        return true;
      }

      else {
        return false;
      }
    }

    return false;
  }
}
