import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convo/components/chat_bubble.dart';
import 'package:convo/components/my_text_field.dart';
import 'package:convo/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;

  const ChatPage(
      {Key? key, required this.receiverUserEmail, required this.receiverUserID})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    //only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);
      // clear the text controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.receiverUserEmail),
          backgroundColor: Colors.white,
        ),
        body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  // topLeft: Radius.circular(40),
                  // topRight: Radius.circular(40),
                  ),
              color: Colors.black),
          child: Column(children: [
            SizedBox(
              height: 30,
            ),
            // messages
            Expanded(child: _buildMessageList()),

            // user input
            _buildMessageInput(),
            SizedBox(
              height: 25,
            )
          ]),
        ));
  }

  // build message list

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the messages to the right if the sender is the current user , otherwise to the left

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment:
                (data['senderId'] == _firebaseAuth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            mainAxisAlignment:
                (data['senderId'] == _firebaseAuth.currentUser!.uid)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              // Text(data['senderEmail']),
              ChatBubble(message: data['message'])
            ]),
      ),
    );
  }
  // build message input

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Card(
        child: Row(children: [
          IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.connect_without_contact,
                size: 35,
              )),
          //textfield
          Expanded(
            child: TextField(
              controller: _messageController,
              obscureText: false,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 245, 243, 243))),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                  hintText: 'Enter Text',
                  hintStyle: const TextStyle(color: Colors.black26)),
            ),
          ),

          //send button
          IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.near_me_outlined,
                size: 35,
              ))
        ]),
      ),
    );
  }
}
