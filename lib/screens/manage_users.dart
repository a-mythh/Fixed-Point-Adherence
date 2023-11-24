import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:Fixed_Point_Adherence/models/user.dart';
import 'package:Fixed_Point_Adherence/widgets/userItem.dart';
import 'package:flutter/material.dart';

DatabaseHelper databaseHelper = DatabaseHelper();

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({required this.currentUser, super.key});

  final String currentUser;

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  String _selectedAccType = 'Admin';
  final List<String> _accTypeList = ['User', 'Admin'];
  List<User> users = [];
  bool _isLoading = false;
  String _error = '';


  // load zones to display
  void _loadAccounts() async {
    try {
      final fetchedAccounts = await databaseHelper.getsUsersBasedOnAccountType(_selectedAccType.toLowerCase());

      // when no data is present in database
      if (fetchedAccounts == null) {
        setState(() {
          _isLoading = false;
        });
        return null;
      }

      final List<User> loadedAccounts = [];

      for (final row in fetchedAccounts) {
        String username = row['username'];
        String password = row['password'];
        String accType = row['accType'];

        User user = User(username: username, password: password, accType: accType);
        loadedAccounts.add(user);
      }

      setState(() {
        users = loadedAccounts;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong. Please try again later!';
        print(error);
      });
    }
  }

  // delete plant
  void _deleteUser(User user) async {
    try {
      await databaseHelper.deleteRecordUser(user.username);
      _loadAccounts();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade200,
        title: const Text('Manage Users'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [

            // dropdown to select account type
            DropdownButtonFormField(
              borderRadius: BorderRadius.circular(30),
              // add some decoration to the drop down menu
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                labelText: "Select Account Type",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
              ),

              items: _accTypeList
                  .map((accType) => DropdownMenuItem(
                        value: accType,
                        child: Text(accType),
                      ))
                  .toList(),

              // what happens when a value is selected
              onChanged: (value) {
                setState(() {
                  _selectedAccType = value as String;
                  _loadAccounts();
                });
              },
            ),
          
            const SizedBox(height: 30),

            // display accounts present in that given account type
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...users.map(
                    (user) => UserItem(
                      user: user,
                      deleteUser: _deleteUser,
                      disabled: user.username == widget.currentUser ? true : false,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}