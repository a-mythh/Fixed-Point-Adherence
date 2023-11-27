import 'package:Fixed_Point_Adherence/auth/auth_module.dart';
import 'package:Fixed_Point_Adherence/models/user.dart';
import 'package:Fixed_Point_Adherence/utility/CustomSnackbar.dart';
import 'package:flutter/material.dart';

class UserItem extends StatefulWidget {
  const UserItem({
    required this.user,
    required this.deleteUser,
    required this.disabled,
    super.key,
  });

  final User user;
  final Function deleteUser;
  final bool disabled;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();

    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    passwordController.dispose();

    super.dispose();
  }

  // dialog box to change password
  void _changePasswordDialog(User user) async {
    final newPassword = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        title: const Text('Change Password?', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    const TextSpan(text: 'Enter new password for '),
                    TextSpan(
                      text: widget.user.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                    const TextSpan(text: '\'s account.')
                  ]),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              autocorrect: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              )),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(passwordController.text);
              passwordController.text = '';
            },
            child: Text(
              'Change',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );

    bool status = await AuthModule.resetPassword(user.username, newPassword);

    final snackbar = status
        ? showCustomSnackbar(
            text: 'Password changed successfully',
            colour: 'success',
          )
        : showCustomSnackbar(
            text: 'Error occurred while changing password.',
            colour: 'failure',
          );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.user.username,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            IconButton(
              onPressed: () {
                _changePasswordDialog(widget.user);
              },
              icon: const Icon(Icons.lock_reset_rounded),
            ),
            IconButton(
              onPressed: widget.disabled
                  ? null
                  : () async {
                      final result = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                          title: const Text('Are you sure?',
                              textAlign: TextAlign.center),
                          content: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: Theme.of(context).textTheme.bodyLarge,
                                children: [
                                  const TextSpan(
                                      text:
                                          'This action will permanently delete '),
                                  TextSpan(
                                    text: widget.user.username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink,
                                    ),
                                  ),
                                  const TextSpan(text: '\'s account.')
                                ]),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(
                                'Delete',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (result == null || !result) {
                        return;
                      }

                      widget.deleteUser(widget.user);
                    },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
