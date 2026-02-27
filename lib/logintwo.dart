import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cengel_deneme3/kullanicianasayfa.dart';
import 'package:cengel_deneme3/sifremiunuttum.dart';  // ForgotPasswordScreen sayfasını import et
import 'package:cloud_firestore/cloud_firestore.dart';

class LogintwoScreen extends StatefulWidget {
  @override
  _LogintwoScreenState createState() => _LogintwoScreenState();
}

class _LogintwoScreenState extends State<LogintwoScreen> {
  final TextEditingController useroneController = TextEditingController();
  final TextEditingController lockoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? errorMessage;

  @override
  void dispose() {
    useroneController.dispose();
    lockoneController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: useroneController.text.trim(),
        password: lockoneController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users') // koleksiyon adın buysa
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          String role = userDoc['role'];

          if (role == 'user') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SirenScreen()),
            );
          } else {
            setState(() {
              errorMessage = "Bu giriş sadece kullanıcılar içindir.";
            });
            await _auth.signOut(); // Uzman değilse çıkış yaptır
          }
        } else {
          setState(() {
            errorMessage = "Kullanıcı bilgisi bulunamadı.";
          });
          await _auth.signOut();
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = "Geçersiz e-posta veya şifre.";
      });
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
            bottom: -60,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Rectangle 6.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            left: -25,
            top: -40,
            child: Image.asset(
              'assets/images/butterfly2.png',
              height: 220.0,
              width: 160.0,
            ),
          ),
          Positioned(
            right: -5,
            top: 10,
            child: Image.asset(
              'assets/images/butterfly1.png',
              height: 250.0,
              width: 160.0,
            ),
          ),
          Column(
            children: [
              SizedBox(height: 25.0),
              _buildLoginHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 150.0),
                        _buildInputLabel(context, "E-Posta Adresiniz:"),
                        _buildInputField(
                          controller: useroneController,
                          prefixImagePath: 'assets/images/user.png',
                        ),
                        SizedBox(height: 38.0),
                        _buildInputLabel(context, "Şifreniz:"),
                        _buildInputField(
                          controller: lockoneController,
                          prefixImagePath: 'assets/images/lock.png',
                          obscureText: true,
                        ),
                        if (errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              errorMessage!,
                              style: TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
                          ),
                        SizedBox(height: 8.0),
                        _buildForgotPasswordLink(context),
                        SizedBox(height: 68.0),
                        _buildRoundedButton(context, "Giriş Yap", _signIn),
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
                        SizedBox(height: 40.0),
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
            "GİRİŞ YAP",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20.0),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String prefixImagePath,
    bool obscureText = false,
  }) {
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

  Widget _buildForgotPasswordLink(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(right: 18.0),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
            ); // Şifremi Unuttum butonuna tıklanınca ForgotPasswordScreen sayfasına geçiş yapılır
          },
          child: Text(
            "Şifremi Unuttum",
            style: Theme.of(context).textTheme.bodyMedium,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Colors.white,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
