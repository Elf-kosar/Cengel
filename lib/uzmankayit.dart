import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cengel_deneme3/uzmangiris.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UzmankayitScreen extends StatefulWidget {
  @override
  _LoginkayitScreenState createState() => _LoginkayitScreenState();
}

class _LoginkayitScreenState extends State<UzmankayitScreen> {
  final TextEditingController useroneController = TextEditingController();
  final TextEditingController lockoneController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController mezuniyetController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController diplomaController = TextEditingController();
  final TextEditingController uzmanlikController = TextEditingController();


  @override
  void dispose() {
    useroneController.dispose();
    lockoneController.dispose();
    phoneController.dispose();
    mezuniyetController.dispose();
    emailController.dispose();
    diplomaController.dispose();
    uzmanlikController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    String email = emailController.text.trim();
    String password = lockoneController.text.trim();
    String username = useroneController.text.trim();
    String phone = phoneController.text.trim();
    String mezuniyet = mezuniyetController.text.trim();
    String diploma = diplomaController.text.trim();
    String uzmanlik = uzmanlikController.text.trim();
    String role = "expert"; // uzman rolü

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: "E-posta ve şifre boş bırakılamaz!");
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Firestore'a kullanıcı bilgilerini kaydet
      await FirebaseFirestore.instance.collection('expert').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'username': username,
        'phone': phone,
        'mezuniyet': mezuniyet,
        'diploma': diploma,
        'uzmanlik': uzmanlik,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(msg: "Kayıt başarılı!");
      print("Uzman başarıyla kaydedildi: ${userCredential.user!.email}");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UzmanGirisScreen()),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Hata: ${e.toString()}");
      print("Kayıt hatası: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/images/geri_tusu.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFFFFFFFF),
      ),
      body: Stack(
        children: [
          Positioned(
            right: 10,
            top: 0,
            child: Image.asset(
              'assets/images/butterfly3.png',
              height: 90.0,
              width: 90.0,
            ),
          ),
          Column(
            children: [
              SizedBox(height: 0),
              _buildLoginHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        _buildInputLabel(context, "Adınız Soyadınız:"),
                        _buildInputField(controller: useroneController, prefixImagePath: 'assets/images/user.png'),
                        SizedBox(height: 10.0),
                        _buildInputLabel(context, "E-Posta Adresiniz:"),
                        _buildInputField(controller: emailController, prefixImagePath: 'assets/images/mail.png'),
                        SizedBox(height: 10.0),
                        _buildInputLabel(context, "Telefon Numaranız:"),
                        _buildInputField(controller: phoneController, prefixImagePath: 'assets/images/phone.png'),
                        SizedBox(height: 10.0),
                        _buildInputLabel(context, "Üniversite Mezuniyet Yılınız:"),
                        _buildInputField(controller: mezuniyetController, prefixImagePath: 'assets/images/mezuniyet.png'),
                        SizedBox(height: 10.0),
                        _buildInputLabel(context, "Uzmanlık Alanınız:"),
                        _buildInputField(controller: uzmanlikController, prefixImagePath: 'assets/images/uzmanlik.png'),
                        SizedBox(height: 10.0),
                        _buildInputLabel(context, "Diploma Seri No:"),
                        _buildInputField(controller: diplomaController, prefixImagePath: 'assets/images/diploma.png'),
                        SizedBox(height: 10.0),
                        _buildInputLabel(context, "Şifreniz:"),
                        _buildInputField(controller: lockoneController, prefixImagePath: 'assets/images/lock.png', obscureText: true),
                        SizedBox(height: 10.0),
                        _buildRoundedButton(context, "Kayıt ol", signUp),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 110.0,
                            child: Divider(
                              thickness: 2,
                              color: Color(0xFFA78CAC),
                            ),
                          ),
                        ),
                        SizedBox(height: 50.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginHeader(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Text(
            "UZMAN KAYIT OL",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(backgroundColor: Color(0xFFFFFFFF),
            ),
          ),
          SizedBox(height: 5.0),
        ],
      ),
    );
  }

  Widget _buildInputLabel(BuildContext context, String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildInputField({required TextEditingController controller, required String prefixImagePath, bool obscureText = false}) {
    return Padding(
      padding: EdgeInsets.only(right: 4.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(prefixImagePath, height: 22.0, width: 24.0),
          ),
          contentPadding: EdgeInsets.fromLTRB(24.0, 32.0, 12.0, 32.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Color(0xFFA78CAC), width: 1.0),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedButton(BuildContext context, String text, VoidCallback onPressed) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          backgroundColor: Colors.white,
        ),
        child: Text(text, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
