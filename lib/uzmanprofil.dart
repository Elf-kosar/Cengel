import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class UzmanProfileScreen extends StatefulWidget {
  @override
  _UzmanProfileScreenState createState() => _UzmanProfileScreenState();
}

class _UzmanProfileScreenState extends State<UzmanProfileScreen> {
  final _formKey = GlobalKey<FormState>(); // Form doğrulama için
  final _aciklamaController = TextEditingController();
  final _calismaSaatleriController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String? _uzmanId; // Uzman ID'sini saklamak için
  bool _isLoading = true; // Yükleme durumunu kontrol etmek için

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => MyApp()),
          (Route<dynamic> route) => false,
    );
  }
  @override
  void initState() {
    super.initState();
    _loadexpertData(); // Sayfa yüklendiğinde uzman verilerini çek
  }

  // Uzman verilerini Firestore'dan çeken fonksiyon
  Future<void> _loadexpertData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // 'uzmanlar' koleksiyonunda, mevcut kullanıcının ID'sine sahip belgeyi bul
        final uzmanDoc = await _firestore
            .collection('uzmanlar')
            .where('kullaniciId', isEqualTo: user.uid)
            .get()
            .then((snapshot) => snapshot.docs.isNotEmpty ? snapshot.docs.first : null); // Eğer sonuç varsa ilkini al

        if (uzmanDoc != null) {
          _uzmanId = uzmanDoc.id; // Uzman ID'sini sakla
          final uzmanData = uzmanDoc.data();
          _aciklamaController.text = uzmanData['aciklama'] ?? ''; // Veriyi controller'a yükle, null ise boş string
          _calismaSaatleriController.text = uzmanData['calismaSaatleri'] ?? '';
        }
      }
    } catch (e) {
      print("Hata: Uzman verisi yüklenirken hata oluştu: $e"); // Hata durumunda log yazdır
      // Hata mesajı gösterebilirsiniz.
    } finally {
      setState(() {
        _isLoading =
        false; // Yükleme tamamlandığında durumu güncelle (başarılı veya başarısız)
      });
    }
  }

  // Kaydetme işlemini yapan fonksiyon
  Future<void> _kaydet() async {
    if (_formKey.currentState!.validate()) { // Form doğrulamasını yap
      try {
        final user = _auth.currentUser;
        if (user != null) {
          if (_uzmanId == null) {
            // Eğer uzman kaydı yoksa yeni bir tane oluştur
            final yeniUzman = await _firestore.collection('uzmanlar').add({
              'kullaniciId': user.uid,
              'aciklama': _aciklamaController.text,
              'calismaSaatleri': _calismaSaatleriController.text,
            });
            _uzmanId = yeniUzman.id;
          } else {
            // Eğer uzman kaydı varsa güncelle
            await _firestore.collection('uzmanlar').doc(_uzmanId).update({
              'aciklama': _aciklamaController.text,
              'calismaSaatleri': _calismaSaatleriController.text,
            });
          }


          ScaffoldMessenger.of(context).showSnackBar( // Kullanıcıya geri bildirim ver
            SnackBar(
              content: Text('Profiliniz başarıyla kaydedildi.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        print("Hata: Veri kaydetme hatası: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil kaydedilirken bir hata oluştu: $e'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _aciklamaController.dispose();
    _calismaSaatleriController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator())); // Yüklenirken bunu göster
    }
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 41,
              height: 41,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFFFFFFFF), width: 2),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/geri_tusu.png',
                  width: 41,
                  height: 41,
                ),
              ),
            ),
          ),
        ),
        title: Text("Profilim", style: TextStyle(color: Color(0xFF4B2B52))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(  // Form widget'ı eklendi
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFEADAED),
                child: Center(
                  child: Image.asset(
                    'assets/images/profil.png',
                    width: 41,
                    height: 41,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text("Profilim",
                  style: TextStyle(fontSize: 25, color: Color(0xFF4B2B52))),
              SizedBox(height: 60),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Danışanlarınız için Kendinizi Tanıtan Bir Açıklama Yazınız:",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              TextFormField( // TextField yerine TextFormField kullanıldı
                controller: _aciklamaController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFF4B2B52)),
                  ),
                  filled: true,
                  fillColor: Color(0xFFF4F4F6),
                ),
                validator: (value) {  // Form doğrulama
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir açıklama girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("İstediğiniz Çalışma Saatlerinizi Girin:",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              TextFormField(  // TextField yerine TextFormField
                controller: _calismaSaatleriController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFF4B2B52)),
                  ),
                  filled: true,
                  fillColor: Color(0xFFF4F4F6),
                ),
                validator: (value) {  // Form doğrulama
                  if (value == null || value.isEmpty) {
                    return 'Lütfen çalışma saatlerinizi girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF4F4F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Color(0xFF4B2B52)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                onPressed: _kaydet, // Kaydet fonksiyonunu çağır
                child: Text("Kaydet",
                    style: TextStyle(
                        color: Color(0xFF4B2B52),
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.red),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                onPressed:_signOut,
                child: Text("Çıkış Yap",
                    style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}