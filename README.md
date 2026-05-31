# Todo App - Modern Flutter Uygulaması

Modern ve şık bir Flutter todo uygulaması. SharedPreferences ve Provider kullanan profesyonel yapı.

## ✨ Özellikler

- ✅ **Not Ekleme**: Başlık ve açıklama ile yeni notlar ekleyin
- ✅ **Not Düzenleme**: Oluşturulan notları düzenleyin
- ✅ **Not Silme**: Tek tek veya tüm notları silin
- ✅ **Tamamlandı İşaretleme**: Notları tamamlandı olarak işaretleyin
- ✅ **Reorder**: Notları sürükleyerek yeniden sıralayın
- ✅ **İstatistikler**: Toplam, tamamlanan ve bekleyen not sayılarını görün
- ✅ **Modern UI**: Şık ve modern tasarım
- ✅ **Kalıcı Depolama**: SharedPreferences ile verileri kaydedin
- ✅ **State Management**: Provider kullanarak reaktif arayüz

## 📁 Proje Yapısı

```
lib/
├── main.dart                          # Uygulama başlangıç noktası
├── theme/
│   └── app_theme.dart                # Tema tanımlamaları
├── constants/
│   └── app_strings.dart              # Tüm metin sabitleri
├── models/
│   └── todo_model.dart               # Todo veri modeli
├── services/
│   └── todo_service.dart             # SharedPreferences servisi
├── providers/
│   └── todo_provider.dart            # Provider state management
├── pages/
│   └── home.dart                     # Ana sayfa
├── dialogs/
│   └── add_edit_todo_dialog.dart     # Ekleme/Düzenleme diyaloğu
└── widgets/
    └── modern_todo_tile.dart         # Not kartı widget'ı
```

## 🛠️ Teknolojiler

- **Flutter**: UI framework
- **Provider**: State management
- **SharedPreferences**: Yerel veri depolama
- **flutter_slidable**: Kaydırılabilir aksiyonlar
- **Lottie**: Animasyonlar
- **UUID**: Benzersiz ID oluşturma

## 🚀 Kurulum ve Çalıştırma

```bash
# Bağımlılıkları yükle
flutter pub get

# Uygulamayı çalıştır
flutter run
```

## 💾 Veritabanı Yapısı

Todo nesneleri JSON formatında SharedPreferences'da saklanır:

```json
{
  "id": "uuid",
  "title": "Not Başlığı",
  "description": "Not Açıklaması",
  "isCompleted": false,
  "createdAt": "2024-01-01T00:00:00.000Z",
  "updatedAt": "2024-01-01T00:00:00.000Z"
}
```

## 📖 Kullanım Kılavuzu

### Not Ekleme
1. Sağ alttaki **"+"** butonuna tıklayın
2. Not başlığını girin
3. *(Opsiyonel)* Not açıklaması girin
4. **"Ekle"** butonuna tıklayın

### Not Düzenleme
1. Not kartında **"..."** menüsüne tıklayın
2. **"Düzenle"** seçeneğini seçin
3. Değişiklikleri yapın
4. **"Güncelle"** butonuna tıklayın

### Not Silme
1. Not kartını **sağa kaydırın** veya **"..."** menüsünden seçin
2. **Kırmızı "Sil"** butonuna tıklayın
3. Silmeyi onaylayın

### Notu Tamamlandı Olarak İşaretleme
Not kartındaki **dairenin üzerine tıklayın**

### Notları Yeniden Sıralama
Notu **uzun basılı tutarak sürükleyin** yeni konumuna

## 🏗️ Dosya Açıklamaları

### `main.dart`
- Uygulama giriş noktası
- Provider ve TodoService setupini içerir
- Tema ve navigation ayarlarını yapılandırır

### `theme/app_theme.dart`
- Koyu (dark) tema tanımlamaları
- Renk sabitleri (primary, accent, error, warning, success)
- Text stilleri ve komponent tasarımları

### `models/todo_model.dart`
- Todo veri sınıfı
- JSON serileştirme/deserileştirme
- CopyWith deseni ile immutable updates

### `services/todo_service.dart`
- SharedPreferences ile iletişim
- Verileri okuma/yazma işlemleri
- CRUD operasyonları (Create, Read, Update, Delete)

### `providers/todo_provider.dart`
- State management sınıfı
- TodoService'i kullanır
- UI'ye değişiklikleri bildirir (ChangeNotifier pattern)

### `pages/home.dart`
- Ana sayfa
- Notların listesini gösterir
- Diyalog açma işlemlerini yönetir
- İstatistikleri ve boş durum gösterir

### `dialogs/add_edit_todo_dialog.dart`
- Not ekleme/düzenleme diyaloğu
- Form validasyonu
- Provider'ı kullanarak veri kaydeder

### `widgets/modern_todo_tile.dart`
- Tekil not kartı widget'ı
- Kaydırılabilir aksiyonlar (slidable)
- Düzenleme, silme ve toggle işlevleri

### `constants/app_strings.dart`
- Tüm metin sabitleri
- Kolay lokalizasyon
- Tek bir yerden yönetim

## 🔌 API Referansı

### TodoProvider Metodları

```dart
// Notları yükle
await todoProvider.loadTodos();

// Not ekle
await todoProvider.addTodo(
  title: 'Başlık',
  description: 'Açıklama',
);

// Not güncelle
await todoProvider.updateTodo(
  id: 'todo-id',
  title: 'Yeni Başlık',
  description: 'Yeni Açıklama',
);

// Notu tamamlandı olarak işaretle/kaldır
await todoProvider.toggleTodo('todo-id');

// Not sil
await todoProvider.deleteTodo('todo-id');

// Tüm notları sil
await todoProvider.deleteAllTodos();

// Notları yeniden sırala
await todoProvider.reorderTodos(oldIndex, newIndex);

// İstatistikler
int totalCount = todoProvider.totalCount;           // Toplam not sayısı
int completedCount = todoProvider.completedCount;   // Tamamlanan not sayısı
int pendingCount = todoProvider.pendingCount;       // Bekleyen not sayısı
bool isEmpty = todoProvider.isEmpty;                // Boş mu kontrol et
List<Todo> todos = todoProvider.todos;              // Tüm notları al
```

## 🎨 UI Özellikleri

- **Responsive Design**: Tüm ekran boyutlarına uygun
- **Dark Theme**: Modern koyu tema
- **Smooth Animations**: Geçiş ve animasyonlar
- **Lottie Animations**: Boş durum animasyonu
- **Custom Icons**: Material Design ikonları
- **Gradient Effects**: Şık gradient arka planlar

## ⚙️ Ayarlamalar

### Tema Değişiklikleri
`lib/theme/app_theme.dart` dosyasında renkleri ve stilleri değiştirebilirsiniz.

### Metin Değişiklikleri
`lib/constants/app_strings.dart` dosyasında tüm metinleri güncelleyebilirsiniz.

### Veritabanı Anahtarı
`lib/services/todo_service.dart` dosyasında `_todosKey` değişkenini değiştirebilirsiniz.

## 📝 Notlar

- Tüm veriler cihazda SharedPreferences kullanılarak saklanır
- Veriler cloud'a senkron edilmez (yerel depolama)
- Uygulama silinirse veriler de silinir
- Yedekleme ve restore işlevleri mevcut değildir

## 🐛 Bilinen Problemler

Şu anda bilinen bir problem bulunmamaktadır.

## 📄 Lisans

Bu proje MIT lisansı altında yapılmıştır.
