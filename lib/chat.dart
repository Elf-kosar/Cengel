import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GenelChatScreen extends StatefulWidget {
  @override
  _GenelChatScreenState createState() => _GenelChatScreenState();
}

class _GenelChatScreenState extends State<GenelChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final _auth = FirebaseAuth.instance;

  // Mesaj gönderme
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) {
      return;
    }

    final user = _auth.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('messages').add({
          'message': message,
          'senderId': user.uid,
          'senderEmail': user.email,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print('Mesaj gönderilemedi: $e');
      }
    }
  }

  // Mesajları listeleme
  Widget _buildMessageList() {
    final currentUser = _auth.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .orderBy('timestamp')
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data?.docs ?? [];

        return ListView.builder(
          reverse: false,
          itemCount: messages.length,
          itemBuilder: (ctx, index) {
            final messageData = messages[index].data() as Map<String, dynamic>;
            final isMe = messageData['senderId'] == currentUser?.uid;
            final senderEmail = messageData['senderEmail'] ?? '';
            final senderInitial = senderEmail.isNotEmpty
                ? senderEmail[0].toUpperCase()
                : '?';

            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (!isMe)
                      CircleAvatar(
                        backgroundColor: Colors.purple[300],
                        radius: 16,
                        child: Text(
                          senderInitial,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    if (!isMe) SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.purple[100] : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft:
                            isMe ? Radius.circular(12) : Radius.circular(0),
                            bottomRight:
                            isMe ? Radius.circular(0) : Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          messageData['message'] ?? '',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    if (isMe) SizedBox(width: 8),
                    if (isMe)
                      CircleAvatar(
                        backgroundColor: Colors.purple[300],
                        radius: 16,
                        child: Text(
                          senderInitial,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kız Kıza Sohbet'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Mesajınızı yazın...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
