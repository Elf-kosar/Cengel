import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'menu.dart';
import 'sahte_cagri.dart'; // FakeCallScreen sayfan varsa, yoksa düzelt

class SirenScreen extends StatefulWidget {
  const SirenScreen({Key? key}) : super(key: key);

  @override
  State<SirenScreen> createState() => _SirenScreenState();
}

class _SirenScreenState extends State<SirenScreen> {
  static const MethodChannel _channel = MethodChannel('com.example.volume_listener');

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  int volumeKeyPressCount = 0;
  DateTime lastPressTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  Future<void> _methodCallHandler(MethodCall call) async {
    if (call.method == "volumePressed") {
      final now = DateTime.now();
      final difference = now.difference(lastPressTime).inMilliseconds;

      if (difference < 1000) {
        volumeKeyPressCount++;
      } else {
        volumeKeyPressCount = 1;
      }

      lastPressTime = now;

      if (volumeKeyPressCount >= 5) {
        volumeKeyPressCount = 0;

        if (!mounted) return;

        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FakeCallScreen()),
        );

        if (!mounted) return;

        setState(() {
          // UI güncellemesi gerekiyorsa burada yap
        });
      }
    }
  }

  void _toggleSiren() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      // Assets klasöründe 'assets/ses/siren.mp3' olduğundan emin ol
      await _audioPlayer.play(AssetSource('ses/siren.mp3'), volume: 1.0);
      // Döngü için set looping
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _channel.setMethodCallHandler(null); // Listener iptal edildi
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 100),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Çengel butonu (şu an boş)
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(100),
                      backgroundColor: const Color(0xFF512357),
                      elevation: 10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/cengel_log.png',
                          width: 170,
                          height: 170,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'ÇENGEL',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 60,
            right: 30,
            child: ElevatedButton(
              onPressed: _toggleSiren,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
                backgroundColor: isPlaying ? Colors.red : const Color(0xFFF4F4F6),
                elevation: 5,
              ),
              child: Image.asset(
                'assets/images/siren.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Image.asset('assets/images/menu.png'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuSayfasi()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
