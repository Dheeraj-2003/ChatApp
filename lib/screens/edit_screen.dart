// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  const EditScreen(this.user, {super.key});

  final ChatUser user;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  File? _pickedImage;

  final nameController = TextEditingController();

  final numController = TextEditingController();

  void _onSave(BuildContext context) async {
    if (numController.text != widget.user.number) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User number can't be changed once created"),
        ),
      );
      return;
    }
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Your name can't be empty"),
        ),
      );
    }

    if (nameController.text != widget.user.name && _pickedImage == null) {
      try {
        final query = await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: userId)
            .get();
        final docRef = query.docs[0].reference;
        await docRef.update({'username': nameController.text});
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Name Updated successfully'),
          ),
        );
      } on FirebaseException catch (err) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.message ?? 'Edit failed'),
          ),
        );
      }
    }
    if (_pickedImage != null) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('$userId.jpg');
        await storageRef.putFile(_pickedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        final query = await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: userId)
            .get();
        final docRef = query.docs[0].reference;
        await docRef
            .update({'image_url': imageUrl, 'username': nameController.text});
        _pickedImage = null;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile Updated successfully'),
          ),
        );
      } on FirebaseException catch (err) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.message ?? 'Edit failed'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.user.name;
    numController.text = widget.user.number;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.user.name),
          actions: [
            TextButton(
                onPressed: () {
                  _onSave(context);
                },
                child: Text(
                  'Save',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ))
          ],
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 180,
                      backgroundImage: NetworkImage(widget.user.imageUrl),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Edit your Profile photo',
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontSize: 20),
                          ),
                        ),
                        Text(
                          '  :   ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontSize: 20),
                        ),
                        Expanded(child: UserImagePicker((pickedImage) {
                          _pickedImage = pickedImage;
                        })),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: "Name"),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 25),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: numController,
                        decoration: InputDecoration(
                            labelText: "Number",
                            floatingLabelStyle:
                                Theme.of(context).textTheme.labelLarge),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 25),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
