# Psikolojik Destek ve Danışmanlık Uygulaması

Flutter ile geliştirilmiş kapsamlı bir psikolojik destek ve danışmanlık platformu. Kullanıcılar ve uzmanlar arasında güvenli iletişim sağlayan, acil durum özellikleri içeren bir mobil uygulama.

## 🚀 Özellikler

### Kullanıcı Özellikleri
- 👤 **Kullanıcı Kaydı ve Girişi** - Firebase Authentication ile güvenli giriş sistemi
- 💬 **Canlı Sohbet** - Uzmanlarla gerçek zamanlı mesajlaşma
- 🤖 **Chatbot Desteği** - 7/24 otomatik destek
- 📅 **Randevu Takvimi** - Uzmanlarla randevu planlama
- 📝 **Not Defteri** - Kişisel notlar
- 🆘 **Acil Durum Özellikleri**:
  - Sahte çağrı özelliği
  - Siren/acil yardım butonu
- 👥 **Destek Talebi** - Destek uzmanı bulma ve talep sistemi

### Uzman Özellikleri
- 👨‍⚕️ **Uzman Paneli** - Danışan yönetimi
- 📊 **Danışan Takibi** - Danışanların geçmişini görüntüleme
- 💬 **Özel Chat** - Danışanlarla birebir iletişim
- 📅 **Randevu Yönetimi** - Takvim ve randevu takibi
- 📞 **Arama ve Çağrıları Yanıtlama** - Gelen destek taleplerini yönetme

## 🛠️ Teknolojiler

- **Framework**: Flutter 3.7+
- **Backend**: Firebase
  - Firebase Authentication (Kimlik doğrulama)
  - Cloud Firestore (Veritabanı)
- **Önemli Paketler**:
  - `table_calendar` - Takvim yönetimi
  - `video_player` - Video içerik oynatma
  - `audioplayers` - Ses içeriği
  - `permission_handler` - Uygulama izinleri
  - `volume_listener` - Ses kontrolü
  - `http` - API iletişimi

## 📋 Gereksinimler

- Flutter SDK 3.7.0 veya üzeri
- Dart SDK 3.7.0 veya üzeri
- Firebase projesi (Firebase Console'dan oluşturulmalı)
- Android Studio / VS Code
- Android SDK (Android geliştirme için)
- Xcode (iOS geliştirme için - sadece macOS)

## 🔧 Kurulum

1. **Projeyi klonlayın**
```bash
git clone https://github.com/[kullanici-adi]/cengel_deneme3.git
cd cengel_deneme3
```

2. **Bağımlılıkları yükleyin**
```bash
flutter pub get
```

3. **Firebase yapılandırması**
   - Firebase Console'dan yeni bir proje oluşturun
   - Android için `google-services.json` dosyasını `android/app/` klasörüne ekleyin
   - iOS için `GoogleService-Info.plist` dosyasını `ios/Runner/` klasörüne ekleyin
   - `firebase_options.dart` dosyasını yapılandırın

4. **Uygulamayı çalıştırın**
```bash
flutter run
```

## 📱 Desteklenen Platformlar

- ✅ Android
- ✅ iOS
- ⚠️ Web (Sınırlı özellikler)
- ⚠️ Windows (Sınırlı özellikler)
- ⚠️ Linux (Sınırlı özellikler)
- ⚠️ macOS (Sınırlı özellikler)

## 🏗️ Proje Yapısı

```
lib/
├── main.dart                    # Ana uygulama giriş noktası
├── firebase_options.dart        # Firebase yapılandırması
├── giris.dart                   # Giriş ekranları
├── kayit.dart                   # Kayıt ekranları
├── kullanicianasayfa.dart       # Kullanıcı ana sayfası
├── uzmananasayfa.dart           # Uzman ana sayfası
├── chat.dart                    # Chat sistemi
├── chatbot.dart                 # Chatbot
├── ozelchat.dart                # Özel sohbet
├── danisanlarim.dart            # Danışan listesi
├── destekistekleri.dart         # Destek talepleri
├── takvimsayfasi.dart           # Takvim
├── sahte_cagri.dart             # Sahte çağrı özelliği
├── siren_uzman.dart             # Acil durum özellikleri
└── services/                    # Servis katmanı
```

## 🔐 Güvenlik

- ⚠️ `google-services.json` ve `firebase_options.dart` dosyaları hassas bilgiler içerir
- Bu dosyalar `.gitignore` ile hariç tutulmuştur
- Kendi Firebase projenizi oluşturmalı ve yapılandırmalısınız

## 📄 Lisans

Bu proje özel bir projedir.

## 👥 İletişim

Sorularınız için lütfen iletişime geçin.
