import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/her_message_bubble.dart';
import '../../widgets/message_field_box.dart';
import '../../widgets/my_message_bubble.dart';

class ChatScreen extends StatefulWidget {
  static const name = 'chat-screen';

  Chat chat;

  ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late CollectionReference messages = FirebaseFirestore.instance.collection('chats/${widget.chat.id}/messages');

  late Stream<QuerySnapshot> messageStream = messages
      .orderBy(
        'createdAt',
        descending: false,
      )
      .snapshots();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://cdn4.iconfinder.com/data/icons/avatar-1-2/100/Avatar-16-512.png'),
          ),
        ),
        title: Text("${widget.chat.name} - ${widget.chat.type} - 1/${widget.chat.amount}"),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: messageStream,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView(
                      //orderBy: 'createdAt',
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                        return (data['senderId'] == authProvider.user!.uid)
                            ? MyMessageBubble(
                                message: data['message'] ?? '',
                              )
                            : HerMessageBubble(message: data['message'] ?? '', author: data['senderName'] ?? '');
                      }).toList(),
                    );
                  },
                ),
              ),

              /// Caja de texto de mensajes
              MessageFieldBox(onSubmitted: (value) async {
                await messages.add({
                  'message': value,
                  'senderId': authProvider.user!.uid,
                  'senderName': authProvider.user!.displayName ?? 'Test',
                  'createdAt': DateTime.now(),
                });

                return true;
              }),
            ],
          ),
        ),
      ),
    );
  }
}
