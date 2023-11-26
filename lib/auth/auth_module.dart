import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

DatabaseHelper databaseHelper = DatabaseHelper();

class AuthModule {
  static final key = encrypt.Key.fromUtf8("e16ce888a20dadb8");
  static final iv = encrypt.IV.fromUtf8("e16ce888a20dadb8");
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  /// ***************** SIGN UP ******************
  static Future<bool> signUp(
      String username, String password, String accType) async {
    try {
      // encrypt the password
      final encryptedPassword = encrypter.encrypt(
        password,
        iv: iv,
      );

      // insert new user details into the database
      await databaseHelper.insertRecordUser(
          username, encryptedPassword.base64, accType);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// ***************** LOGIN ******************
  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    // stores the user type and if allowed to login
    Map<String, dynamic> result = {
      'userType': 'user',
      'isLogin': false,
    };

    // get user details if it exists
    List<Map<String, dynamic>>? singleUserDetails =
        await DatabaseHelper().getRecordsSingleUser(username);

    // print(singleUserDetails!.isEmpty.toString() + ' hi');

    // if user does not exist show error
    if (singleUserDetails!.isEmpty) {
      // Fluttertoast.showToast(
      //   msg: 'Invalid credentials! Please try again.',
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      // );

      return result;
    }

    // get user details
    var dataRow = singleUserDetails[0];
    final storedPasswordBase64 = dataRow['password'];
    final accType = dataRow['accType'];

    // check if password is present for that user
    if (storedPasswordBase64 != null) {
      // decrpyt the password
      final storedPassword = encrypt.Encrypted.fromBase64(storedPasswordBase64);
      // print(storedPasswordBase64);
      final decryptedPassword = encrypter.decrypt(storedPassword, iv: iv);

      // if password is correct
      if (password == decryptedPassword) {
        // login as normal user
        if (accType == 'user') {
          // show message on successful login
          // Fluttertoast.showToast(
          //   msg: 'Successfully Logged In!',
          //   toastLength: Toast.LENGTH_LONG,
          //   gravity: ToastGravity.BOTTOM,
          //   backgroundColor: Colors.green,
          //   textColor: Colors.white,
          // );

          result['isLogin'] = true;

          return result;
        }

        // login as administrative user
        else if (accType == 'admin') {
          // show message on successful login
          Fluttertoast.showToast(
            msg: 'Successfully Logged In!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          result['isLogin'] = true;
          result['userType'] = 'admin';

          return result;
        }
      }

      // if not a normal or admin user
      else {
        return result;
      }
    }
    // if password absent for that user
    else {
      return result;
    }

    return result;
  }

  /// ***************** CHANGE PASSWORD ******************
  static Future<bool> resetPassword(
    String username,
    String newPassword,
  ) async {
    // if password correctly entered
    try {
      // encrypt and store the password
      final encryptedPassword = encrypter.encrypt(
        newPassword,
        iv: iv,
      );

      // update the user's password in the database
      await databaseHelper.updateAccountPassword(
          username, encryptedPassword.base64);

      return true;
    } catch (e) {
      return false;
    }
  }
}
