import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'sahte_cagri.dart'; // Sahte çağrı sayfanın adı buysa, yoksa düzelt

class SirenUzmanScreen extends StatefulWidget {
  const SirenUzmanScreen({Key? key}) : super(key: key);

  @override
  State<SirenUzmanScreen> createState() => _SirenUzmanScreenState();
}

class _SirenUzmanScreenState extends State<SirenUzmanScreen> {
  static const MethodChannel _channel = MethodChannel('com.example.volume_listener');

  VideoPlayerController? _controller;
  bool isPlaying = false;

  int volumeKeyPressCount = 0;
  DateTime lastPressTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    // Native'den gelen volume tuşu eventi dinle
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

        if (mounted) {
          // FakeCallScreen kapanana kadar bekle, sonra sayacı sıfırla
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FakeCallScreen()),
          );

          // FakeCallScreen kapandıktan sonra sayacı sıfırla (ekstra garanti)
          setState(() {
            volumeKeyPressCount = 0;
          });
        }
      }

    }

  }

  void _toggleSirenVideo() async {
    if (_controller == null) {
      _controller = VideoPlayerController.asset('assets/ses/siren.mp3');
      await _controller!.initialize();
      _controller!.setLooping(true);
    }

    if (isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    // MethodChannel için ayrıca remove yapmaya gerek yok, widget dispose oluyor.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(

        children: [
          Positioned(
            top: 70,
            left: 10,
            child: IconButton(
              icon: Image.asset('assets/images/geri_tusu.png'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

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
              onPressed: _toggleSirenVideo,
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
        ],
      ),
    );
  }
}
