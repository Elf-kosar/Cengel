import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'danisanlarim_sonrasi.dart';
import 'ozelchat.dart';

class DanisanlarimScreen extends StatelessWidget {
  const DanisanlarimScreen({super.key});


  Stream<List<String>> _getOnayliDanisanlarStream() async* {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      yield [];
      return;
    }
    final uzmanUid = currentUser.uid;

    final destekIstekleriStream = FirebaseFirestore.instance
        .collection('expert')
        .doc(uzmanUid)
        .collection('destek_istekleri')
        .where('durum', isEqualTo: 'onaylandi')
        .snapshots();

    await for (final snapshot in destekIstekleriStream) {
      List<String> danisanlar = [];

      for (var doc in snapshot.docs) {
        final kullaniciId = doc.data()['kullanici_id'];
        if (kullaniciId != null) {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(kullaniciId)
              .get();

          final username = userDoc.data()?['username'] ?? 'Bilinmeyen Kullanıcı';
          danisanlar.add(username);
        }
      }

      yield danisanlar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 41,
            height: 41,
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFFFFFFFF), width: 2),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/geri_tusu.png',
                width: 41,
                height: 41,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        title: const Text(
          "Danışanlarım",
          style: TextStyle(
            color: Color(0xFF4B2B52),
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<List<String>>(
        stream: _getOnayliDanisanlarStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata oluştu: ${snapshot.error}'));
          }

          final danisanlar = snapshot.data ?? [];

          if (danisanlar.isEmpty) {
            return const Center(child: Text('Henüz onaylanmış danışan yok.'));
          }

          return ListView.builder(
            itemCount: danisanlar.length,
            itemBuilder: (context, index) {
              return Card(
                color: const Color(0xFFF4F4F6),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                child: ListTile(
                  leading: Text(
                    "${index + 1}.",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  title: Text(
                    danisanlar[index],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF4B2B52),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MesajlasmalarPage(
                          chatId: "example_chat_id", // Bu genellikle iki kullanıcının ID'lerinden oluşur
                          receiverName: "Alıcı Adı",
                          receiverEmail: "alici@email.com",
                        ),
                      ),
                    );
                  },


                ),
              );
            },
          );
        },
      ),
    );
  }
}
