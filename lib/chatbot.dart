import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  List<Map<String, String>> messages = [];
  TextEditingController controller = TextEditingController();
  bool isLoading = false;

  Future<void> sendMessage() async {
    final userMessage = controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "text": userMessage});
      controller.clear();
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse("http://172.31.157.159:8000/chat"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "query": userMessage,
        "user_id": "flutter_user"
      }),

    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final botReply = data['response'];
      setState(() {
        messages.add({"sender": "bot", "text": botReply});
        isLoading = false;
      });
    } else {
      setState(() {
        messages.add({"sender": "bot", "text": "Bir hata oluştu. Lütfen tekrar deneyin."});
        isLoading = false;
      });
    }
  }

  Widget buildMessage(Map<String, String> message) {
    final isUser = message["sender"] == "user";
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/images/cengelyanindayim.png'),
              radius: 25,
            ),
            SizedBox(width: 6),
          ],
          if (isUser) Spacer(), // kullanıcı mesajı sağda olsun
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Color(0xFFEADAED) : Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(16),
              ),

              child: Text(
                message["text"] ?? "",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/images/user.png'),
              radius: 25,
            ),
          ],
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/images/geri_tusu.png'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Çengel Yanındayım",
          style: TextStyle(
            color: Color(0xFF4B2B52),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),


      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) => buildMessage(messages[index]),
            ),
          ),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                      controller: controller,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      enableSuggestions: true,
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: "Mesaj yazınız",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    )

                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send,  color: Color(0xFF4B2B52)),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}