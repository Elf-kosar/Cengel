import 'package:cengel_deneme3/takvimsayfasi.dart';
import 'package:flutter/material.dart';
import 'chat.dart';
import 'chatbot.dart';
import 'destekciler.dart';
import 'kullaniciprofil.dart';
import 'ozelchat.dart';

class MenuSayfasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/images/geri_tusu.png'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),

              // Profil Resmi için yuvarlak buton
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                customBorder: CircleBorder(),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0xFFD2B6D7),
                  child: Image.asset(
                      'assets/images/profil.png'
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Profilim',
                style: TextStyle(
                  color: Color(0xFFD2B6D7),
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 50),

              // Menü Öğeleri
              _buildMenuItem(
                iconWidget: Image.asset('assets/images/cengel.png', width: 50, height: 50),
                text: 'Çengel Destekçileri',
                trailingWidget: Transform.scale(
                  scale: 3.5,
                  child: Image.asset('assets/images/destekciler.png', width: 30, height: 40),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DestekcilerPage()),
                  );
                },
              ),
              SizedBox(height: 30),
              _buildMenuItem(
                iconWidget: Image.asset('assets/images/cengel.png', width: 50, height: 50),
                text: 'Çengel Yanındayım',
                trailingWidget: Transform.scale(
                  scale: 3.5,
                  child: Image.asset('assets/images/cengelyanindayim.png', width: 40, height: 24),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatbotScreen()),
                  );
                },
              ),
              SizedBox(height: 30),
              _buildMenuItem(
                iconWidget: Image.asset('assets/images/cengel.png', width: 50, height: 50),
                text: 'Çengel Yakınında',
                trailingWidget: Transform.scale(
                  scale: 3.5,
                  child: Image.asset('assets/images/cengelyakininda.png', width: 24, height: 24),
                ),
                onTap: () {},
              ),
              SizedBox(height: 30),
              _buildMenuItem(
                iconWidget: Image.asset('assets/images/cengel.png', width: 50, height: 50),
                text: 'Çengel Sohbet Odası',
                trailingWidget: Transform.scale(
                  scale: 3.5,
                  child: Image.asset('assets/images/sohbetodasi.png', width: 24, height: 24),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GenelChatScreen()),
                  );
                },
              ),
              SizedBox(height: 30),
              _buildMenuItem(
                iconWidget: Image.asset('assets/images/cengel.png', width: 50, height: 50),
                text: 'Çengel Takvim',
                trailingWidget: Transform.scale(
                  scale: 3.5,
                  child: Image.asset('assets/images/cengeltakvim.png', width: 24, height: 24),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TakvimSayfasi()),
                  );
                },
              ),
              SizedBox(height: 30),
              _buildMenuItem(
                iconWidget: Image.asset('assets/images/cengel.png', width: 50, height: 50),
                text: 'Çengel Mesajlarım',
                trailingWidget: Transform.scale(
                  scale: 3.5,
                  child: Image.asset('assets/images/mesajlasmalarim.png', width: 24, height: 24),
                ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MesajlasmalarPage(
                          chatId: "example_chat_id", // Bu genellikle iki kullanıcının ID'lerinden oluşur
                          receiverName: "Alya",
                          receiverEmail: "alici@email.com",
                        ),
                      ),
                    );
                  }
              ),

            ],
          ),
        ),
      ),
    );
  }

  // Menü Kartları için ortak widget
  Widget _buildMenuItem({
    required Widget iconWidget,
    required String text,
    required VoidCallback onTap,
    IconData? trailingIcon,
    Widget? trailingWidget,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Color(0xFFD2B6D7),
          boxShadow: [
            BoxShadow(
              //color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            iconWidget,
            SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Color(0xFF4B2B52),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (trailingWidget != null)
              trailingWidget
            else if (trailingIcon != null)
              Icon(trailingIcon, color: Color(0xFF957DAD), size: 24),
          ],
        ),
      ),
    );
  }

  // Danışanlarım ve Destek Taleplerim gibi kartlar için
  Widget buildListItem(BuildContext context, String title, String imagePath, Widget? nextScreen) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      elevation: 5,
      color: const Color(0xFFD2B6D7),
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        leading: Image.asset(
          imagePath,
          width: 70,
          height: 70,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 25,
            fontFamily: 'Manrope',
          ),
        ),
        onTap: () {
          if (nextScreen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => nextScreen),
            );
          }
        },
      ),
    );
  }
}
