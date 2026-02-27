import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DestekIstekleriScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/images/geri_tusu.png', width: 41, height: 41),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Destek İstekleri",
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('destek_istekleri')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final User? currentUser = FirebaseAuth.instance.currentUser;

          if (currentUser == null) {
            return Center(child: Text('Giriş yapılmamış.'));
          }

          final destekIstekleri = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['uzmanId'] == currentUser.uid;
          }).toList();

          final bekleyenIstekler = destekIstekleri
              .where((doc) =>
          (doc.data() as Map<String, dynamic>)['durum'] == 'beklemede')
              .toList();

          final onaylananlar = destekIstekleri
              .where((doc) =>
          (doc.data() as Map<String, dynamic>)['durum'] == 'onaylandi')
              .toList();

          final reddedilenler = destekIstekleri
              .where((doc) =>
          (doc.data() as Map<String, dynamic>)['durum'] == 'reddedildi')
              .toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Bekleyen İstekler"),
                  _buildIstekListesi(bekleyenIstekler, true),
                  const SizedBox(height: 16),
                  _buildSectionTitle("Onaylananlar"),
                  _buildIstekListesi(onaylananlar, false),
                  const SizedBox(height: 16),
                  _buildSectionTitle("Reddedilenler"),
                  _buildIstekListesi(reddedilenler, false),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4B2B52),
          ),
        ),
      ],
    );
  }

  Widget _buildIstekListesi(
      List<QueryDocumentSnapshot> istekler, bool isBekleyen) {
    if (istekler.isEmpty) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Hiç destek isteği yok.',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: istekler.map((istekDoc) {
            final data = istekDoc.data() as Map<String, dynamic>;
            final istek = data['isim'] ?? 'İsim yok';
            return _buildIstekTile(istek, istekDoc, isBekleyen);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildIstekTile(
      String istek, QueryDocumentSnapshot istekDoc, bool isBekleyen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: isBekleyen
            ? ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              backgroundColor: const Color(0xFFF4F4F6)),
          onPressed: () async {
            await istekDoc.reference.update({'durum': 'reddedildi'});
            print("$istek reddedildi");
          },
          child: Image.asset(
            'assets/images/olumsuz_tusu.png',
            width: 24,
            height: 24,
          ),
        )
            : null,
        title: Text(
          istek,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: isBekleyen
            ? ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              backgroundColor: const Color(0xFFF4F4F6)),
          onPressed: () async {
            await istekDoc.reference.update({'durum': 'onaylandi'});
            print("$istek onaylandı");
          },
          child: Image.asset(
            'assets/images/olumlu_tusu.png',
            width: 24,
            height: 24,
          ),
        )
            : null,
      ),
    );
  }
}
