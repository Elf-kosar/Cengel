import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kayıt olma ve Firestore'a rol kaydetme
  Future<String?> registerUser(String email, String password, String role) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'password': password,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null; // Başarılıysa hata yok
    } catch (e) {
      return e.toString(); // Hata mesajı döndür
    }
  }

  // Giriş yapma ve rol kontrolü
  Future<String?> loginUser(String email, String password, String expectedRole) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(userCredential.user!.uid).get();

      final role = userDoc.get('role');

      if (role != expectedRole) {
        await _auth.signOut();
        return 'Bu giriş sadece $expectedRole hesabı içindir.';
      }

      return null; // Giriş başarılı, hata yok
    } catch (e) {
      return e.toString();
    }
  }
}
