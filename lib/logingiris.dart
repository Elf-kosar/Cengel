import 'package:cengel_deneme3/uzmangiris.dart';
import 'package:flutter/material.dart';
import 'package:cengel_deneme3/logintwo.dart';

class ButonEkrani extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF), // Sabit arka plan rengi
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/images/geri_tusu.png'), // Geri tuşu görseli
          onPressed: () {
            Navigator.pop(context); // Geri gitmek için pop fonksiyonu
          },
        ),
        backgroundColor: Color(0xFFFFFFFF),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButton(
              context,
              'Kullanıcı \n Girişi',
              Color(0xFF4B2B52), // Kullanıcı Girişi butonu rengi
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogintwoScreen()), // LoginGiris sayfanıza geçiş
                );
              },
            ),
            SizedBox(height: 20),
            _buildButton(
              context,
              'Uzman \n Girişi',
              Color(0xFFF4F4F6), // Güncellenmiş renk (F4F4F6)
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UzmanGirisScreen()), // LoginGiris sayfanıza geçiş
                );
                // Psikolog Girişi butonuna basıldığında yapılacak işlem
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 300,
      height: 300,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: CircleBorder(),
          padding: EdgeInsets.all(20),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 45,
            fontFamily: 'Manrope',
            //fontWeight: FontWeight.bold,
            color: color == Color(0xFFF4F4F6) ? Colors.black : Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}


