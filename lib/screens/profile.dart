import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/edit_screen.dart';
import 'package:chat_app/screens/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView(this.user, this.me, {super.key});

  final ChatUser user;
  final bool me;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(user.name),
          actions: [
            if (me)
              TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => EditScreen(user)));
                  },
                  icon: const Icon(Icons.edit),
                  label: Text(
                    'Edit Profile',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  )),
          ],
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 180,
                    backgroundImage: NetworkImage(user.imageUrl),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Number :',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 35),
                      ),
                      Text(
                        user.number,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 25),
                      ),
                    ],
                  ),
                  if (me)
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: TextButton.icon(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (ctx) => const SignInScreen()),
                              (route) => false);
                        },
                        icon: const Icon(Icons.logout),
                        label: Text(
                          'Logout',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ));
  }
}
