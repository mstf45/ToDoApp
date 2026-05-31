# 🏗️ Todo App - Mimari Dokümantasyon

## Genel Yapı

```
┌─────────────────────────────────────────────────┐
│           Presentation Layer (UI)               │
│  ┌───────────────────────────────────────────┐  │
│  │ Pages (home.dart)                         │  │
│  │ Dialogs (add_edit_todo_dialog.dart)      │  │
│  │ Widgets (modern_todo_tile.dart)          │  │
│  └───────────────────────────────────────────┘  │
└────────────┬────────────────────────────────────┘
             │
┌────────────┴────────────────────────────────────┐
│       State Management Layer (Provider)         │
│  ┌───────────────────────────────────────────┐  │
│  │ TodoProvider (ChangeNotifier)             │  │
│  │ - loadTodos()                             │  │
│  │ - addTodo()                               │  │
│  │ - updateTodo()                            │  │
│  │ - deleteTodo()                            │  │
│  │ - toggleTodo()                            │  │
│  │ - reorderTodos()                          │  │
│  └───────────────────────────────────────────┘  │
└────────────┬────────────────────────────────────┘
             │
┌────────────┴────────────────────────────────────┐
│         Data Layer (Services)                   │
│  ┌───────────────────────────────────────────┐  │
│  │ TodoService (SharedPreferences)           │  │
│  │ - getTodos()                              │  │
│  │ - saveTodos()                             │  │
│  │ - addTodo()                               │  │
│  │ - updateTodo()                            │  │
│  │ - deleteTodo()                            │  │
│  └───────────────────────────────────────────┘  │
└────────────┬────────────────────────────────────┘
             │
┌────────────┴────────────────────────────────────┐
│    Local Storage (SharedPreferences)            │
└─────────────────────────────────────────────────┘
```

## Katman Açıklamaları

### 1. Presentation Layer (UI)

#### `pages/home.dart`
- Ana sayfa widget'ı
- Liste gösterimi ve layout
- Diyalog tetikleyicisi
- Provider ile Consumer
- ReorderableListView desteği

**Sorumluluğu:**
- Kullanıcı arayüzü gösterme
- Kullanıcı etkileşimlerini işleme
- Provider'dan veri okuma
- Dialog açma/kapatma

#### `dialogs/add_edit_todo_dialog.dart`
- Not ekleme/düzenleme formu
- Form validasyonu
- Provider action tetikleme
- Dialog navigasyonu

**Sorumluluğu:**
- Form alanlarını yönetme
- Input validasyonu
- Provider metodlarını çağırma
- Hata gösterme

#### `widgets/modern_todo_tile.dart`
- Tekil not kartı
- Kaydırılabilir aksiyonlar
- Animasyonlar
- Popup menüsü

**Sorumluluğu:**
- Not kartı UI'ı
- Etkileşim işleme
- Toggle ve silme işlevleri

### 2. State Management Layer (Provider)

#### `providers/todo_provider.dart`
- ChangeNotifier tabanlı state management
- Tüm business logic
- Data transformasyonu
- Notification gönderme

**Sorumluluğu:**
- State'i tutma
- Service'i koordine etme
- Hesaplamaları yapma (istatistikler)
- Listeners'ı bilgilendirme

**Metodlar:**
```dart
// Veri yönetimi
Future<void> loadTodos()
Future<void> addTodo(title, description)
Future<void> updateTodo(id, title, description)
Future<void> deleteTodo(id)
Future<void> toggleTodo(id)
Future<void> deleteAllTodos()
Future<void> reorderTodos(oldIndex, newIndex)

// Hesaplamalar
int get totalCount
int get completedCount
int get pendingCount
bool get isEmpty
List<Todo> get todos
```

### 3. Data Layer (Services)

#### `services/todo_service.dart`
- SharedPreferences ile iletişim
- JSON serileştirme
- CRUD operasyonları
- Veri persistency

**Sorumluluğu:**
- Verileri okuma/yazma
- SharedPreferences yönetimi
- JSON dönüşümleri
- Depolama tutarlılığı

**Metodlar:**
```dart
Future<List<Todo>> getTodos()
Future<void> saveTodos(List<Todo>)
Future<void> addTodo(Todo)
Future<void> updateTodo(Todo)
Future<void> deleteTodo(String id)
Future<void> toggleTodo(String id)
Future<void> deleteAllTodos()
```

### 4. Model Layer

#### `models/todo_model.dart`
- Veri struktur tanımı
- JSON serileştirme
- Immutable pattern (copyWith)
- Validation

**Özellikleri:**
```dart
class Todo {
  final String id;              // UUID
  final String title;           // Not başlığı
  final String description;     // Not açıklaması
  final bool isCompleted;       // Tamamlandı mı
  final DateTime createdAt;     // Oluşturulma tarihi
  final DateTime? updatedAt;    // Güncellenme tarihi
}
```

## Veri Akışı

### Not Ekleme Akışı

```
1. User Action (FAB Click)
         ↓
2. Dialog Açılır
   ├─ Title input
   └─ Description input
         ↓
3. User "Ekle" tıkla
         ↓
4. Dialog validasyon
   └─ Title boş mu?
         ↓
5. Provider.addTodo(title, description)
         ↓
6. TodoProvider yaratır Todo obje
   └─ UUID oluştur
   └─ Timestamp ekle
         ↓
7. TodoService.addTodo() çağır
   └─ Tüm todos al
   └─ Yeni todo ekle
   └─ JSON formatında kaydet
         ↓
8. Provider notifyListeners()
         ↓
9. UI yenilenir
   └─ List güncellenir
   └─ İstatistikler güncellenir
   └─ Dialog kapanır
```

### Not Güncelleme Akışı

```
1. User Action (Düzenle tıkla)
         ↓
2. Dialog açılır (Todo ile önceden doldurulmuş)
   ├─ Title: current value
   └─ Description: current value
         ↓
3. User değişiklikleri yap
         ↓
4. "Güncelle" tıkla
         ↓
5. Validasyon
         ↓
6. Provider.updateTodo(id, title, description)
   └─ Todo obje al
   └─ Yeni değerlerle copyWith
   └─ updatedAt güncelleştir
         ↓
7. TodoService.updateTodo()
   └─ Index bul
   └─ Yeni objeyi yerleştir
   └─ Kaydet
         ↓
8. Provider notifyListeners()
         ↓
9. UI yenilenir
```

### Not Silme Akışı

```
1. User Action (Sil tıkla)
         ↓
2. Onay dialog gösterilir
         ↓
3. User "Sil"i tıkla
         ↓
4. Provider.deleteTodo(id)
   └─ Todos listesinden kaldır
         ↓
5. TodoService.deleteTodo(id)
   └─ Filtrelenmiş listeyi kaydet
         ↓
6. Provider notifyListeners()
         ↓
7. UI yenilenir
   └─ Not kartı kaldırılır
   └─ İstatistikler güncellenir
```

## State Yönetimi Detayları

### Provider Başlatma

```dart
// main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (_) => TodoProvider(todoService)..loadTodos(),
    ),
  ],
  child: MaterialApp(...),
)
```

### UI'de Consumption

```dart
// Listening to changes
Consumer<TodoProvider>(
  builder: (context, todoProvider, child) {
    return Text('Toplam: ${todoProvider.totalCount}');
  },
)

// Triggering actions
ElevatedButton(
  onPressed: () {
    context.read<TodoProvider>().addTodo(
      title: 'Title',
      description: 'Description',
    );
  },
)
```

## Veri Depolama Format

### SharedPreferences Key
```dart
static const String _todosKey = 'todos';
```

### Saklanan Format
```
String listesi (JSON arrays)
[
  {"id":"...","title":"...","description":"...","isCompleted":false,"createdAt":"...","updatedAt":null},
  {...}
]
```

## Hata Yönetimi

### Validasyonlar

```dart
// Dialog'da
if (title.isEmpty) {
  showSnackBar('Not başlığı boş olamaz');
  return;
}

// Delete confirmação
showDialog() // Onaylama dialog
```

### Exception Handling

```dart
// Service'de try-catch yok
// SharedPreferences senkron operasyon
// Hata durumunda crash
// Üretim için daha robust hale getirilebilir
```

## Performans Optimizasyonları

### 1. ReorderableListView
- Efficiently handles reordering
- Key-based identification
- Minimal rebuilds

### 2. Consumer Pattern
- Selective rebuilding
- Only affected widgets rebuild
- Efficient change detection

### 3. JSON Serialization
- Native Dart serialization
- No external libraries
- Fast encoding/decoding

## Extension Noktaları

### Yeni Feature Ekleme
1. Model'e yeni field ekle
2. Service'te serialization güncelle
3. Provider'da getter/setter ekle
4. UI'de görüntüle

### Senkronizasyon Ekleme
```dart
// TodoProvider'da
Future<void> syncWithCloud() async {
  // API çağrısı
  // Local update
  // notifyListeners()
}
```

### Backup Sistemi
```dart
// TodoService'de
Future<String> exportAsJson() async {
  // JSON format'ında export
}

Future<void> importFromJson(String json) async {
  // JSON'dan import
}
```

## Testing Yapısı

### Unit Tests
```dart
// Test TodoProvider
// Test TodoService
// Test Todo model
```

### Widget Tests
```dart
// Test home page
// Test dialogs
// Test tiles
```

### Integration Tests
```dart
// End-to-end test
// Full user flow
```

## Teknoloji Stack'i

| Kategori | Teknoloji | Versiyon |
|----------|-----------|----------|
| State | Provider | 6.1.2 |
| Storage | SharedPreferences | 2.2.2 |
| ID | UUID | 4.0.0 |
| UI | flutter_slidable | 3.1.1 |
| Animasyon | Lottie | 3.1.2 |

---

**Mimari, skalabilir ve sürdürülebilir olacak şekilde tasarlanmıştır.**
