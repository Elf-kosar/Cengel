import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            // Üst sağdaki elips
            Positioned(
              top: -80,
              right: -110,
              child: Container(
                width: 289,
                height: 306,
                decoration: BoxDecoration(
                  color: Color(0xFF4B245C),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Alt soldaki elips
            Positioned(
              bottom: -250,
              left: -318,
              child: Container(
                width: 611,
                height: 604,
                decoration: BoxDecoration(
                  color: Color(0xFF4B245C),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Logo ve metin
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/cengel_log.png',
                    width: 228,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Ç  E  N  G  E  L",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Manrope',
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
