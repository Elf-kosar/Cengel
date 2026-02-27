// fake_call_display_screen.dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'kullanicianasayfa.dart';

// Arama ekranının kendisi, durumu yönetmek için Stateful
class FakeCallDisplayScreen extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final VoidCallback onCallEnd;

  const FakeCallDisplayScreen({
    Key? key,
    required this.audioPlayer,
    required this.onCallEnd,
  }) : super(key: key);

  @override
  _FakeCallDisplayScreenState createState() => _FakeCallDisplayScreenState();
}

class _FakeCallDisplayScreenState extends State<FakeCallDisplayScreen> {
  bool _isCallAccepted = false; // Arama kabul edildi mi?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.grey[900]!],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Üst Kısım: Arayan Bilgileri (Her iki durumda da sabit kalacak)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Center(
                    child: Text(
                      _isCallAccepted ? 'Görüşme Devam Ediyor' : 'Gelen Arama',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Babacığım',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          '+90 532 456 78 90',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Arama kabul edildiğinde süre vb. eklenebilir
                  if (_isCallAccepted) // Sadece kabul edilince görünsün
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        '00:00', // Gerçek zamanlı sayaç eklenebilir
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),

              // Alt Kısım: Butonlar (Duruma göre değişecek)
              Align(
                alignment: Alignment.bottomCenter,
                child: _isCallAccepted
                    ? _buildAcceptedCallControls() // Arama kabul edildiğinde
                    : _buildIncomingCallControls(), // Gelen arama durumunda
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Gelen Arama Kontrolleri (İlk durum)
  Widget _buildIncomingCallControls() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCallOptionButton(
            icon: Icons.message,
            label: 'Mesaj',
            onTap: () {
              // Mesaj gönderme mantığı
            },
          ),
          GestureDetector(
            onTap: _endCall,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.call_end,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
          GestureDetector(
            onTap: _acceptCall, // Cevapla butonuna basıldığında
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.call,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
          _buildCallOptionButton(
            icon: Icons.access_time,
            label: 'Hatırlat',
            onTap: () {
              // Hatırlatma mantığı
            },
          ),
        ],
      ),
    );
  }

  // Kabul Edilmiş Arama Kontrolleri (İkinci durum)
  Widget _buildAcceptedCallControls() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[850]!.withOpacity(0.9), // Hafif şeffaf koyu gri panel
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Üst Sıra Butonları
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCallOptionButton(
                icon: Icons.add,
                label: 'Arama ekle',
                onTap: () {},
                backgroundColor: Colors.grey[700]!.withAlpha(61),
                iconColor: Colors.white,
              ),
              _buildCallOptionButton(
                icon: Icons.pause,
                label: 'Aramayı beklet',
                onTap: () {},
                backgroundColor: Colors.grey[700]!.withAlpha(61),
                iconColor: Colors.white,
              ),
              _buildCallOptionButton(
                icon: Icons.bluetooth,
                label: 'Bluetooth',
                onTap: () {},
                backgroundColor: Colors.grey[700]!.withAlpha(61),
                iconColor: Colors.white,
              ),
            ],
          ),
          SizedBox(height: 24),

          // Alt Sıra Butonları
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCallOptionButton(
                icon: Icons.volume_up,
                label: 'Hoparlör',
                onTap: () {},
                backgroundColor: Colors.grey[700]!.withAlpha(61),
                iconColor: Colors.white,
              ),
              _buildCallOptionButton(
                icon: Icons.mic_off,
                label: 'Sessiz',
                onTap: () {},
                backgroundColor: Colors.grey[700]!.withAlpha(61),
                iconColor: Colors.white,
              ),
              _buildCallOptionButton(
                icon: Icons.dialpad,
                label: 'Tuş takımı',
                onTap: () {},
                backgroundColor: Colors.grey[700]!.withAlpha(61),
                iconColor: Colors.white,
              ),
            ],
          ),
          SizedBox(height: 32),

          // Çağrıyı Kapat Butonu
          GestureDetector(
            onTap: _endCall,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.call_end,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  // Ortak buton yapısı için yardımcı metod
  Widget _buildCallOptionButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white.withAlpha(61),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor ?? Colors.white,
              size: 28,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  void _acceptCall() {
    setState(() {
      _isCallAccepted = true; // Arama kabul edildi durumuna geç
    });
    widget.audioPlayer.stop(); // Zil sesini durdur
  }

  void _endCall() {
    widget.onCallEnd(); // (Eğer bu gerekli değilse, silebilirsin)

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SirenScreen()),
    );
  }

}