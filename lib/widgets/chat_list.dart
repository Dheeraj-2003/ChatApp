import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/widgets/chat_tray.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  ChatList({super.key});

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  void _showAlertDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Delete',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteChat(id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteChat(String id) {
    FirebaseFirestore.instance.collection('chats').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('usersId', arrayContains: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No chats to show'),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          final chatdata = snapshot.data!.docs;

          return ListView.builder(
              itemCount: chatdata.length,
              itemBuilder: (context, index) {
                final data = chatdata[index].data();
                final friend = currentUserId == data['usersId'][0]
                    ? ChatUser(
                        name: data['usernames'][1],
                        number: data['users'][1],
                        imageUrl: data['userImages'][1])
                    : ChatUser(
                        name: data['usernames'][0],
                        number: data['users'][0],
                        imageUrl: data['userImages'][0]);
                final currentUser = currentUserId == data['usersId'][0]
                    ? ChatUser(
                        name: data['usernames'][0],
                        number: data['users'][0],
                        imageUrl: data['userImages'][0])
                    : ChatUser(
                        name: data['usernames'][1],
                        number: data['users'][1],
                        imageUrl: data['userImages'][1]);
                Chat chat = Chat(
                    chatId: data['chatId'], user1: currentUser, user2: friend);
                return InkWell(
                    onTap: () {
                      _showAlertDialog(context, chat.chatId);
                    },
                    child: ChatTray(chat, friend));
              });
        });
  }
}
