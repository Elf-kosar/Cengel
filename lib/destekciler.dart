import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DestekcilerPage extends StatelessWidget {
  const DestekcilerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/images/geri_tusu.png'),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Çengel Destekçileri',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF512357),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('uzmanlar').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('Henüz uzman bilgisi bulunmuyor.'));
            }

            final uzmanlar = snapshot.data!.docs;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              itemCount: uzmanlar.length,
              itemBuilder: (context, index) {
                final uzmanDoc = uzmanlar[index];
                final uzmanData = uzmanDoc.data() as Map<String, dynamic>;

                final expertId = uzmanData['kullaniciId']?.toString() ?? '';
                final aciklama = uzmanData['aciklama']?.toString() ?? 'Açıklama Yok';

                if (expertId.isEmpty) {
                  return const SizedBox(); // UID boşsa kart oluşturma
                }

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('expert').doc(expertId).get(),
                  builder: (context, expertSnapshot) {
                    if (expertSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    String isim = 'İsim Yok';
                    if (expertSnapshot.hasData && expertSnapshot.data!.exists) {
                      final expertData = expertSnapshot.data!.data() as Map<String, dynamic>;
                      isim = expertData['username']?.toString() ?? 'İsim Yok';
                    }

                    return _destekciKarti(
                      context,
                      isim: isim,
                      aciklama: aciklama,
                      uzmanUid: expertId,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _destekciKarti(BuildContext context,
      {required String isim, required String aciklama, required String uzmanUid}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ExpansionTile(
        title: Center(
          child: Text(
            isim,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF512357),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          Text(
            aciklama,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEADAED),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final currentUser = FirebaseAuth.instance.currentUser;

                if (currentUser == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Lütfen giriş yapınız.")),
                  );
                  return;
                }

                final uid = currentUser.uid;

                // Kullanıcı adını Firestore'dan çek
                final userDoc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .get();

                final username = userDoc.data()?['username'] ?? 'Bilinmeyen Kullanıcı';

                // Uzmanın destek istekleri koleksiyonuna istek ekle
                final destekIstekRef = FirebaseFirestore.instance
                    .collection('expert')
                    .doc(uzmanUid)
                    .collection('destek_istekleri');

                await destekIstekRef.add({
                  'istek_tarihi': Timestamp.now(),
                  'mesaj': 'Kullanıcı sizden destek talep etti.',
                  'durum': 'beklemede',
                  'kullanici_id': uid,
                  'isim': username,
                  'uzmanId': uzmanUid,
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Randevu isteği gönderildi.')),
                );
              },
              child: const Text('Randevu İsteği Gönder'),
            ),
          ),
        ],
      ),
    );
  }
}
