import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cengel_deneme3/logintwo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginkayitScreen extends StatefulWidget {
  @override
  _LoginkayitScreenState createState() => _LoginkayitScreenState();
}

class _LoginkayitScreenState extends State<LoginkayitScreen> {
  final TextEditingController useroneController = TextEditingController();
  final TextEditingController lockoneController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthYearController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    useroneController.dispose();
    lockoneController.dispose();
    phoneController.dispose();
    birthYearController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    String email = emailController.text.trim();
    String password = lockoneController.text.trim();
    String username = useroneController.text.trim();
    String phone = phoneController.text.trim();
    String birthYear = birthYearController.text.trim();
    String role = "user"; // Bu ekran kullanıcılar içinse "user", uzmanlar içinse "expert" yap

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: "E-posta ve şifre boş bırakılamaz!");
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'username': username,
        'phone': phone,
        'birthYear': birthYear,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(msg: "Kayıt başarılı!");
      print("Kullanıcı başarıyla kaydedildi: ${userCredential.user!.email}");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogintwoScreen()),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Hata: ${e.toString()}");
      print("Kayıt hatası: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA78CAC),
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/images/geri_tusu.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFFA78CAC),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: -70,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Rectangle 6.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            right: -5,
            top: 0,
            child: Image.asset(
              'assets/images/butterfly1.png',
              height: 160.0,
              width: 160.0,
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
                        SizedBox(height: 45),
                        _buildInputLabel(context, "Kullanıcı Adınız:"),
                        _buildInputField(controller: useroneController, prefixImagePath: 'assets/images/user.png'),
                        SizedBox(height: 10.0),
                        _buildInputLabel(context, "E-Posta Adresiniz:"),
                        _buildInputField(controller: emailController, prefixImagePath: 'assets/images/mail.png'),
                        SizedBox(height: 10.0),
                        _buildInputLabel(context, "Telefon Numaranız:"),
                        _buildInputField(controller: phoneController, prefixImagePath: 'assets/images/phone.png'),
                        SizedBox(height: 10.0),
                        _buildInputLabel(context, "Doğum Yılınız:"),
                        _buildInputField(controller: birthYearController, prefixImagePath: 'assets/images/gift.png'),
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
            "KAYIT OL",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),
          ),
          SizedBox(height: 10.0),
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
