import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    final String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lütfen e-posta adresinizi girin.")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: ${e.toString()}")),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
            bottom: -250,
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Şifrenizi mi\nUnuttunuz?',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Şifrenizi unuttuysanız endişelenmeyin, kolayca\nsıfırlayabilirsiniz. Bunun için öncelikle e-posta\nadresinizi girerek bize iletmeniz gerekiyor. Ardından,\nsize şifre sıfırlama bağlantısı içeren bir e-posta\ngöndereceğiz. Gelen kutunuza gelen bu bağlantıya\ntıklayarak yeni şifrenizi belirleyebilir ve hesabınıza\ntekrar erişim sağlayabilirsiniz.',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(height: 150),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'E-Posta Adresiniz:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Manrope'),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.white, width: 1.0),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset('assets/images/user.png', height: 24.0, width: 24.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'ornek@mail.com',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: _resetPassword,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Color(0xFF512357), width: 1.0),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      'Gönder',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Manrope'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
