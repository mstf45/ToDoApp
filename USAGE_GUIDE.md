# 📖 Todo App - Kullanım Kılavuzu

## Başlamadan Önce

Uygulamayı çalıştırmak için:

```bash
cd todoapp
flutter pub get
flutter run
```

## 🎯 Ana Özellikler ve Kullanım

### 1️⃣ Not Ekleme

**Yöntem 1: Floating Action Button (FAB)**
- Sayfanın sağ alt köşesindeki **"+"** butonuna tıklayın
- Not başlığını girin (**zorunlu**)
- Note açıklaması girin (opsiyonel)
- **"Ekle"** butonuna tıklayın

**Başarılı İşlem:**
- Not listeye eklenir
- Ekran otomatik kapatılır
- Toplam not sayısı güncellenir

### 2️⃣ Not Düzenleme

**Yöntem 1: Popup Menü**
- Notu bulun
- Kartın sağ tarafındaki **"..."** (üç nokta) menüsüne tıklayın
- **"Düzenle"** seçeneğini seçin
- Başlık ve açıklamayı güncelleyin
- **"Güncelle"** butonuna tıklayın

**Yöntem 2: Kaydırma Gesti**
- Notu sola kaydırın
- **Mavi "Düzenle"** butonuna tıklayın

### 3️⃣ Not Silme

**Yöntem 1: Popup Menü**
- Notu bulun
- **"..."** menüsüne tıklayın
- **"Sil"** seçeneğini seçin
- Onay penceresinde **"Sil"** butonuna tıklayın

**Yöntem 2: Kaydırma Gesti**
- Notu sola kaydırın
- **Kırmızı "Sil"** butonuna tıklayın
- Onay penceresinde **"Sil"** butonuna tıklayın

**Yöntem 3: Toplu Silme**
- Sayfanın sağ üst köşesindeki menüyü açın
- **"Tümünü Sil"** seçeneğini seçin
- Onay penceresinde **"Sil"** butonuna tıklayın

### 4️⃣ Notu Tamamlandı Olarak İşaretleme

**Not Kartında:**
- Not kartının sol tarafındaki **boş daire**ye tıklayın
- Daire dolar ve not şeffaflaşır (tamamlandı işareti)
- Yeniden tıklayarak tamamlanmış işaretini kaldırabilirsiniz

**Görsel İşaretler:**
- ✅ Tamamlanan notlar: Çizili görünür
- ⭕ Tamamlanmamış: Normal görünür

### 5️⃣ Notları Yeniden Sıralama

- Not kartını **uzun basılı tutun**
- **Sürükleyerek** yeni konuma taşıyın
- Bıraktığınız konuma yerleşir
- Sıralaması otomatik kaydedilir

## 📊 İstatistikler Paneli

Sayfanın üst kısmında gösterilen panel:

| İstatistik | Açıklama |
|-----------|----------|
| **Toplam** | Tüm not sayısı (📋 ikon) |
| **Tamamlanan** | İşaretlenmiş notlar (✅ ikon) |
| **Bekleyen** | Henüz yapılmayan notlar (⏰ ikon) |

## 🎨 Arayüz Elemanları

### Başlık Bölümü
```
Bugünün Görevleri
[X görev]
```
Seçenek menüsü: Tüm notları sil

### Not Kartı
```
[✓] Not Başlığı                [...]
    Not Açıklaması
```
- Sol taraf: Tamamlandı checkbox'ı
- Orta: Not başlığı ve açıklaması
- Sağ taraf: Aksiyonlar menüsü

### Boş Durum Sayfası
Not olmadığında:
- Lottie animasyonu
- "Henüz Göreviniz Yok" mesajı
- "Yeni bir görev eklemek için + tuşuna tıklayın"

## ⚙️ İstatistik Şunlar İçin Kullanılır

- **Verimlilik Takibi**: Kaç not tamamladığınız
- **İş Yükü Yönetimi**: Kaç not beklemede
- **Motivasyon**: Başarı oranınızı görün

## 🔐 Veri Güvenliği

- ✅ Tüm veriler **cihazda** saklanır
- ✅ Cloud'a **gönderilmez**
- ⚠️ Uygulama silinirse veriler **silinir**
- ⚠️ Başka cihaza **taşınmaz**

## 💡 İpuçları ve Öneriler

### 1. Etkili Not Yazma
```
❌ Kötü: "Yapılacaklar"
✅ İyi: "Yazı işleri raporunu tamamla"

❌ Kötü: "Alışveriş"
✅ İyi: "Pazarlamaya gitmek"
```

### 2. Başlık ve Açıklama Kullanımı
- **Başlık**: Kısa, öz açıklama
- **Açıklama**: Detaylar, hatırlatıcılar, notlar

Örnek:
```
Başlık: Toplantı hazırlığı
Açıklama: Sunum dosyasını hazırla, 
          raporları yazdır, 
          katılımcı listesini kontrol et
```

### 3. Notları Gruplandırma
Açıklamalar kullanarak notları kategorize edin:
```
[Projeler]
[Kişisel]
[İş]
[Alışveriş]
```

### 4. İşlem Sırasını Optimize Etme
- En önemli notları yukarıya çekin
- Bittikleri zaman işaretleyin
- Motivasyon artışını görün

## 🐛 Sorun Giderme

### Not Kaydedilmiyor
1. Başlığın boş olmadığından emin olun
2. Cihazda yeterli depolama alanı kontrol edin
3. Uygulamayı yeniden başlatın

### Notlar Kayboldu
- Uygulama verilerini temizlediyseniz silinir
- Backup mekanizması bulunmamaktadır
- Yeniden not eklemeniz gerekir

### Uygulama Yavaş
1. Çok sayıda not varsa cihazı yeniden başlatın
2. Başarılı eski notları silin
3. Cihaz depolama alanını kontrol edin

## 📱 Yazılım Gereksinimleri

- **Flutter**: 3.5.4+
- **Android**: 5.0+ (API 21+)
- **iOS**: 11.0+
- **Windows/Mac**: Modern version

## 📞 Sorular ve Yardım

Sorunlarla karşılaşırsanız:

1. Uygulamayı yeniden başlatın
2. Cihazı yeniden başlatın
3. Uygulamayı yeniden kurun
4. Kod loglarını kontrol edin (DevTools)

---

**İyi kullanımlar! 📝✨**
