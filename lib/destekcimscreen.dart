import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ozelchat.dart';

class DestekcimScreen extends StatefulWidget {
  const DestekcimScreen({Key? key}) : super(key: key);

  @override
  State<DestekcimScreen> createState() => _DestekcimScreenState();
}

class _DestekcimScreenState extends State<DestekcimScreen> {
  String? uzmanAdi;
  String? uzmanEmail;
  @override
  void initState() {
    super.initState();
    _girisYapanKullaniciBilgisiGetir();
  }

  Future<void> _girisYapanKullaniciBilgisiGetir() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          uzmanAdi = userDoc.data()?['username'] ?? 'Kullanıcı';
        });
      }
    } catch (e) {
      print('Kullanıcı bilgisi alınırken hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/images/geri_tusu.png'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _butonOlustur(
                text: 'Mesajlaşmalarım',
                icon: Icons.chat_bubble_outline,
                onPressed: () {
                  if (uzmanAdi != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MesajlasmalarPage(
                          chatId: "chat_${FirebaseAuth.instance.currentUser!.uid}_${uzmanAdi!.replaceAll(' ', '_')}", // Chat için benzersiz ID
                          receiverName: uzmanAdi!, // Uzmanın adı
                          receiverEmail: uzmanEmail!, // Uzmanın email'i (uzmanAdi değil)
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                          Text("Kullanıcı bilgisi henüz yüklenmedi")),
                    );
                  }
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _butonOlustur({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          elevation: 5,
          shadowColor: Colors.purple.shade200.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.purple[700], size: 30),
            const SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(
                fontSize: 24,
                color: Colors.purple[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
