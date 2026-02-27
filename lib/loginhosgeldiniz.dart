import 'package:flutter/material.dart';
import 'package:cengel_deneme3/logingiris.dart';
import 'package:cengel_deneme3/loginkayitgiris.dart';

class LoginoneScreen extends StatelessWidget {
  const LoginoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/cengel_log.png',
                          height: 150,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Ç E N G E L",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(),
                ),
              ],
            ),
          ),
          Positioned(
            top: 330,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/kizlar.png',
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildWelcomeSection(context),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Rectangle.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(80),
          topRight: Radius.circular(80),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "HOŞ GELDİNİZ",
              style: theme.textTheme.displaySmall?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 35),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              "Çengel, şiddet veya istismara uğrayan kadınların güvenliğini artırmayı ve desteklenmesini amaçlayan bir uygulamadır. Acil yardım erişimi, yasal bilgilendirme chatbotu ve psikolojik destek ağı gibi özellikler sunarak farkındalık ve dayanışmayı güçlendirmeyi hedefler.",
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 25),
          _buildActionButtons(context),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ButonEkrani()),
            );
          },
          child: Text("Giriş Yap"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginkayitgirisScreen()),
            );
          },
          child: Text("Kayıt Ol"),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }
}
