import 'package:chat_app/models/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages(this.chat, {super.key});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(chat.chatId)
            .collection('messages')
            .orderBy('sentAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No messages to show',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            );
          }

          if (chatSnapshots.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            );
          }

          final loadedMessages = chatSnapshots.data!.docs;

          return ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(bottom: 90, left: 13, right: 13),
              itemCount: loadedMessages.length,
              itemBuilder: (ctx, idx) {
                final currentUser = FirebaseAuth.instance.currentUser!.uid;
                final sender = loadedMessages[idx].data()['userId'];
                return Align(
                  alignment: sender == currentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Card(
                      color: sender == currentUser
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          loadedMessages[idx].data()['text'],
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                        ),
                      )),
                );
              });
        });
  }
}
