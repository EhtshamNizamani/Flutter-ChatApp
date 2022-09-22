import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message.bubble.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: ((ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const Center(child: CircularProgressIndicator());
        }
        var snapDocs = snapshot.data!.docs;
        return ListView.builder(
            reverse: true,
            itemCount: snapDocs.length,
            itemBuilder: (ctx, index) {
              if (user.uid.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              // print(snapDocs[index]['user_image']);
              return MessageBubble(
                snapDocs[index]['text'],
                snapDocs[index]['userId'] == user.uid,
                userName: snapDocs[index]['username'],
                userImage: snapDocs[index]['user_image'],
                key: ValueKey(snapDocs[index].id),
              );
            });
      }),
    );
  }
}
