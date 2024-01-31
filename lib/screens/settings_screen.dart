import 'package:chat_app/screens/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => SignInScreen()),
                );
              })
        ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Card(
          margin: const EdgeInsets.all(10),
          child: Container(
            height: 300,
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('lib\\images\\user (1).png'),
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Event Host Name',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 30),
                )
              ],
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: SizedBox(
              width: 20,
            ),
            titleAlignment: ListTileTitleAlignment.center,
            title: Text(
              'My Profile',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary, fontSize: 25),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: SizedBox(
              width: 20,
            ),
            titleAlignment: ListTileTitleAlignment.center,
            title: Text(
              'Events',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary, fontSize: 25),
            ),
          ),
        ),
      ]),
    );
  }
}
