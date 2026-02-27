import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TakvimSayfasi extends StatefulWidget {
  @override
  _TakvimSayfasiState createState() => _TakvimSayfasiState();
}

class _TakvimSayfasiState extends State<TakvimSayfasi> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _randevular = {};

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _uid;
  String _rol = 'user'; // Varsayılan

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _focusedDay = DateTime.now();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    User? user = _auth.currentUser;

    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    _uid = user.uid;

    // Önce users koleksiyonuna bak
    DocumentSnapshot<Map<String, dynamic>> userDoc =
    await _firestore.collection('users').doc(_uid).get();

    if (userDoc.exists && userDoc.data() != null && userDoc.data()!.containsKey('role')) {
      _rol = userDoc['role'];
    } else {
      // Eğer users içinde yoksa expert koleksiyonuna bak
      DocumentSnapshot<Map<String, dynamic>> expertDoc =
      await _firestore.collection('expert').doc(_uid).get();

      if (expertDoc.exists && expertDoc.data() != null && expertDoc.data()!.containsKey('role')) {
        _rol = expertDoc['role'];
      }
    }

    setState(() {}); // Rol bilgisi güncellendiğinde ekranı yenile
    _loadRandevular();
  }

  Future<void> _loadRandevular() async {
    QuerySnapshot snapshot;
    if (_rol == 'user') {
      snapshot = await _firestore
          .collection('randevular')
          .where('kullaniciId', isEqualTo: _uid)
          .get();
    } else {
      snapshot = await _firestore
          .collection('randevular')
          .where('danismanId', isEqualTo: _uid)
          .get();
    }

    Map<DateTime, List<String>> randevuMap = {};

    for (var doc in snapshot.docs) {
      DateTime tarih = (doc['tarih'] as Timestamp).toDate();
      DateTime key = DateTime.utc(tarih.year, tarih.month, tarih.day);
      String detay =
          '${tarih.hour.toString().padLeft(2, '0')}:${tarih.minute.toString().padLeft(2, '0')} - ${doc['detay']}';

      if (!randevuMap.containsKey(key)) {
        randevuMap[key] = [];
      }
      randevuMap[key]!.add(detay);
    }

    setState(() {
      _randevular = randevuMap;
    });
  }

  void _randevuEkle(DateTime tarih, TimeOfDay saat, String detay) async {
    DateTime tamTarih = DateTime(
      tarih.year,
      tarih.month,
      tarih.day,
      saat.hour,
      saat.minute,
    );

    await _firestore.collection('randevular').add({
      'tarih': Timestamp.fromDate(tamTarih),
      'detay': detay,
      'kullaniciId': _rol == 'user' ? _uid : null,
      'danismanId': _rol == 'expert' ? _uid : null,
    });

    await _loadRandevular();
  }

  void _randevuEkleDialog() async {
    if (_selectedDay == null) return;

    TextEditingController _controller = TextEditingController();
    TimeOfDay? secilenSaat;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Randevu Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Randevu detayı'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                secilenSaat = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
              },
              child: Text('Saat Seç'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (_controller.text.isNotEmpty && secilenSaat != null) {
                _randevuEkle(_selectedDay!, secilenSaat!, _controller.text);
              }
            },
            child: Text('Ekle'),
          )
        ],
      ),
    );
  }

  List<String> _getEventsForDay(DateTime day) {
    return _randevular[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    List<String> seciliGunRandevular = _selectedDay != null
        ? _getEventsForDay(_selectedDay!)
        : [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/images/geri_tusu.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Randevu Takvimi'),
      ),

      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.pink.shade100,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.pink,
                shape: BoxShape.circle,
              ),
            ),
            calendarFormat: CalendarFormat.month,
            rangeSelectionMode: RangeSelectionMode.disabled,
            headerStyle: HeaderStyle(formatButtonVisible: false),
          ),
          const SizedBox(height: 20),
          if (_selectedDay != null) ...[
            ElevatedButton(
              onPressed: _randevuEkleDialog,
              child: Text('Bu güne randevu ekle'),
            ),
            if (seciliGunRandevular.isNotEmpty)
              ...seciliGunRandevular.map((randevu) => ListTile(title: Text(randevu)))
            else
              Text('Bu gün için randevu bulunmamaktadır.'),
          ] else
            Text('Bir tarih seçin.'),
        ],
      ),
    );
  }
}
