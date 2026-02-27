import 'package:cengel_deneme3/siren_uzman.dart';
import 'package:cengel_deneme3/takvimsayfasi.dart';
import 'package:flutter/material.dart';
import 'package:cengel_deneme3/uzmanprofil.dart';
import 'package:cengel_deneme3/danisanlarim.dart';
import 'package:cengel_deneme3/destekistekleri.dart';

import 'notlar.dart';

class UzmanAnaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar rengi
        automaticallyImplyLeading: false, // Geri butonunu kaldırır

      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    backgroundColor: Color(0xFF512357),
                    elevation: 5,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SirenUzmanScreen()), // LoginGiris sayfanıza geçiş
                    );
                    // Çengel logosuna basıldığında yapılacak işlem
                  },
                  child: Image.asset(
                    'assets/images/cengel_log.png',
                    width: 60,
                    height: 60,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 0), // Yuvarlak butonu biraz yukarıya almak için burayı ayarladık
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(15),
                        backgroundColor: Color(0xFFD2B6D7),
                        elevation: 5,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UzmanProfileScreen()),
                        );
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFFD2B6D7),
                        child: Image.asset(
                            'assets/images/profil.png'
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Profilim',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B2B52),
                        fontFamily: 'Manrope',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            // Burada Danışanlarım butonunu DanisanlarScreen() sayfasına yönlendirmek için navigation ekliyoruz
            _buildListItem(context, 'Danışanlarım', 'assets/images/cengel.png', DanisanlarimScreen()),
            _buildListItem(context, 'Destek İstekleri', 'assets/images/cengel.png', DestekIstekleriScreen()),
            _buildListItem(context, 'Notlarım', 'assets/images/cengel.png', NotesPage()),
            _buildListItem(context, 'Randevularım', 'assets/images/cengel.png', TakvimSayfasi()),
          ],
        ),
      ),
    );
  }

  // _buildListItem fonksiyonunda bir 'nextScreen' parametresi ekledik.
  // Bu parametre, tıklanacak butonun hangi sayfaya yönlendireceğini belirler.
  Widget _buildListItem(BuildContext context, String title, String imagePath, Widget? nextScreen) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      elevation: 5,
      color: Color(0xFFD2B6D7),
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Container(
        width: double.infinity,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          leading: Image.asset(
            imagePath,
            width: 70,
            height: 70,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'Manrope',
            ),
          ),
          onTap: () {
            // Eğer nextScreen null değilse, yönlendirme yapılır
            if (nextScreen != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => nextScreen),
              );
            }
          },
        ),
      ),
    );
  }
}


