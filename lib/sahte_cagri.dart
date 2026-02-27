import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'arama_cevaplama.dart';

class FakeCallScreen extends StatefulWidget {
  @override
  _FakeCallScreenState createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends State<FakeCallScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  static const platform = MethodChannel('com.example.volume_listener');

  int _volumePressCount = 0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _requestPermissions();
    _setupVolumeListener();

    // Sayfa açıldıktan 1 saniye sonra sahte arama başlat
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      _playFakeCallSound();
    });
  }

  Future<void> _requestPermissions() async {
    await Permission.audio.request();
    await Permission.phone.request();
  }

  void _setupVolumeListener() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'volumePressed') {
        await _handleVolumePress();
      }
    });
  }

  Future<void> _handleVolumePress() async {
    _volumePressCount++;

    if (_volumePressCount >= 0) {
      _volumePressCount = 0;
      await _playFakeCallSound();
    }
  }

  Future<void> _playFakeCallSound() async {
    try {
      if (!_isPlaying) {
        if (!mounted) return;

        setState(() {
          _isPlaying = true;
        });

        _volumePressCount = 0; // Çağrı başlarken sayaç sıfırlanıyor

        await _audioPlayer.play(AssetSource('ses/galaxy_bells.mp3'));

        if (!mounted) return;
        _showFakeCallDialog();
      }
    } catch (e) {
      print('Ses çalma hatası: $e');
    }
  }

  void _showFakeCallDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.canvas,
          child: Container(
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      Center(
                        child: Text(
                          'Gelen Arama',
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
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.24),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.message,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Mesaj',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
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
                            onTap: _acceptCall,
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
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.24),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Hatırlat',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _acceptCall() {
    if (!mounted) return;

    Navigator.of(context).pop();  // Mevcut dialog'u kapatıyoruz
    _endCall();                   // Çağrıyı bitiriyoruz (örneğin sesi durdur)

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FakeCallDisplayScreen(
          audioPlayer: _audioPlayer,
          onCallEnd: _endCall,
        ),
      ),
    );
  }

  void _endCall() {
    if (!mounted) return;

    Navigator.of(context).pop();
    _audioPlayer.stop();

    setState(() {
      _isPlaying = false;
    });

    _volumePressCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arka Plan Servisi'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sahte Arama Uygulaması Arka Planda Çalışıyor.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            Text(
              '1 sn içerisinde arama başlayacak',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
