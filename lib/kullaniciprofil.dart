import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthYearController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      emailController.text = user.email ?? '';

      // Firestore'dan diğer bilgileri çek
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        nameController.text = data['name'] ?? '';
        phoneController.text = data['phone'] ?? '';
        birthYearController.text = data['birthYear'] ?? '';
      }
    }
  }

  Future<void> _updateUserInfo() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    try {
      // Şifre değişikliği yapılmışsa güncelle
      if (passwordController.text.isNotEmpty) {
        await user.updatePassword(passwordController.text);
      }

      // Firestore'daki kullanıcı bilgilerini güncelle
      await _firestore.collection('users').doc(user.uid).update({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'birthYear': birthYearController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bilgiler başarıyla güncellendi.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Güncelleme başarısız: $e")),
      );
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => MyApp()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF512357),
      appBar: AppBar(
        backgroundColor: Color(0xFF512357),
        title: Text("Profilim", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Image.asset('assets/images/geritusu2.png'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
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
          Column(
            children: [
              SizedBox(height: 10.0),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 90.0),
                      _buildInputLabel("Ad Soyad"),
                      _buildInputField(
                          controller: nameController,
                          iconPath: 'assets/images/user.png'),
                      SizedBox(height: 10.0),
                      _buildInputLabel("E-posta"),
                      _buildInputField(
                          controller: emailController,
                          iconPath: 'assets/images/user.png'),
                      SizedBox(height: 10.0),
                      _buildInputLabel("Telefon Numarası"),
                      _buildInputField(
                          controller: phoneController,
                          iconPath: 'assets/images/phone.png'),
                      SizedBox(height: 10.0),
                      _buildInputLabel("Doğum Yılı"),
                      _buildInputField(
                          controller: birthYearController,
                          iconPath: 'assets/images/gift.png'),
                      SizedBox(height: 10.0),
                      _buildInputLabel("Yeni Şifre"),
                      _buildInputField(
                          controller: passwordController,
                          iconPath: 'assets/images/lock.png',
                          obscureText: true),
                      SizedBox(height: 30.0),
                      _buildRoundedButton("Bilgileri Güncelle", _updateUserInfo),
                      SizedBox(height: 20.0),
                      _buildRoundedButton("Çıkış Yap", _signOut),
                      SizedBox(height: 40.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String iconPath,
    bool obscureText = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: 4.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(iconPath, height: 22.0, width: 24.0),
          ),
          contentPadding: EdgeInsets.fromLTRB(24.0, 24.0, 12.0, 24.0),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedButton(String text, VoidCallback onPressed) {
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
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA78CAC)),
        ),
      ),
    );
  }
}
