import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  static const String routeName = '/user';
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
    );
  }
}
