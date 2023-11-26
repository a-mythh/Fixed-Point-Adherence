import 'package:Fixed_Point_Adherence/helpers/database_helper.dart';
import 'package:Fixed_Point_Adherence/screens/manage_users.dart';
import 'package:flutter/material.dart';

DatabaseHelper databaseHelper = DatabaseHelper();

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({required this.username, super.key});

  final String username;

  @override
  State<AccountsScreen> createState() => _ZoneScreenState();
}

class _ZoneScreenState extends State<AccountsScreen> {
  @override
  void initState() {
    getUsersCount();
    getAdminsCount();
    super.initState();
  }

  int numUsers = 0;
  int numAdmins = 0;

  void getUsersCount() async {
    int count = await databaseHelper.countUsers();
    setState(() {
      numUsers = count;
    });
  }

  void getAdminsCount() async {
    int count = await databaseHelper.countAdmins();
    setState(() {
      numAdmins = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      numAdmins.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontSize: 72),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline),
                              children: [
                                (numAdmins == 1
                                    ? const TextSpan(text: 'ADMIN\n')
                                    : const TextSpan(text: 'ADMINS\n')),
                                (numAdmins == 1
                                    ? const TextSpan(text: 'IS\n')
                                    : const TextSpan(text: 'ARE\n')),
                                const TextSpan(text: 'AVAILABLE'),
                              ]),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 80),
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      numUsers.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontSize: 72),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline),
                              children: [
                                (numUsers == 1
                                    ? const TextSpan(text: 'USER\n')
                                    : const TextSpan(text: 'USERS\n')),
                                (numUsers == 1
                                    ? const TextSpan(text: 'IS\n')
                                    : const TextSpan(text: 'ARE\n')),
                                const TextSpan(text: 'AVAILABLE'),
                              ]),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 150),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // add user button
              InkWell(
                onTap: () async {
                  await Navigator.pushNamed(context, '/new_user');
                  getAdminsCount();
                  getUsersCount();
                },
                borderRadius: BorderRadius.circular(15),
                splashColor: Theme.of(context).primaryColor,
                child: Container(
                  height: 125,
                  width: 170,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.77),
                        Colors.black.withOpacity(0.85),
                        Colors.black.withOpacity(1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person_add,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Add New Account',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // manage user button
              InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ManageUsersScreen(currentUser: widget.username),
                    ),
                  );

                  getAdminsCount();
                  getUsersCount();
                },
                borderRadius: BorderRadius.circular(15),
                splashColor: Theme.of(context).primaryColor,
                child: Container(
                  height: 125,
                  width: 170,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.77),
                        Colors.black.withOpacity(0.85),
                        Colors.black.withOpacity(1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.manage_accounts_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Manage Accounts',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
