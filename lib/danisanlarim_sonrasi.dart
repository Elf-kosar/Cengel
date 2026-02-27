import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ozelchat.dart';

class DanisanSonrasiScreen extends StatefulWidget {
  final String username;

  const DanisanSonrasiScreen({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<DanisanSonrasiScreen> createState() => _DanisanSonrasiScreenState();
}

class _DanisanSonrasiScreenState extends State<DanisanSonrasiScreen> {
  void _goToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget _buildPurpleButton(String text, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.purple.shade400, size: 28),
            const SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(
                fontSize: 20,
                color: Colors.purple.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.calendar_today,
                size: 60,
                color: Colors.purple,
              ),
              const SizedBox(height: 10),
              Text(
                widget.username,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              _buildPurpleButton(
                'Mesajlaşmalarım',
                Icons.message,
                    () {
                  // Burada kendi mesajlaşma sayfana yönlendirme yap
                  // Örnek:
                  _goToPage(MesajlasmalarPage(
                    chatId: "chat_${FirebaseAuth.instance.currentUser!.uid}_opponent_uid", // Chat ID
                    receiverName: "Kullanıcı Adı", // Karşı tarafın adı
                    receiverEmail: 'kullanici@email.com', // opponentEmail yerine receiverEmail
                  ));
                },
              ),
              const SizedBox(height: 20),
              _buildPurpleButton(
                'Notlarım',
                Icons.note,
                    () {
                  // Burada kendi notlar sayfana yönlendirme yap
                  // Örnek:
                  // _goToPage(KendiNotlarSayfanin());
                },
              ),
              const SizedBox(height: 20),
              _buildPurpleButton(
                'Randevularım',
                Icons.event,
                    () {
                  // Burada kendi randevular sayfana yönlendirme yap
                  // Örnek:
                  // _goToPage(KendiRandevularSayfanin());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
