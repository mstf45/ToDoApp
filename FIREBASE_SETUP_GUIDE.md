# Firebase Setup ve Firestore Güvenlik Kuralları

## Firestore Security Rules Sorunu

Eğer notlar Firebase'den gelmiyor ise, muhtemelen **Firestore güvenlik kuralları** hatalı. 

### Firebase Console'da Kontrol Et:

1. **Firebase Console → Firestore Database → Rules sekmesi**
2. Aşağıdaki kuralları kopyala ve yapıştır:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /user_profiles/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /users/{userId}/todos/{todoId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

3. **Publish** butonuna tıkla

## Firestore Veri Yapısı

Doğru yapı:
```
user_profiles/
  └── {uid}/
      ├── uid
      ├── email
      ├── username
      ├── photoUrl
      ├── phoneNumber
      ├── emailVerified
      ├── providerId
      ├── createdAt
      └── lastSeen

users/
  └── {uid}/
      └── todos/
          └── {todoId}/
              ├── id
              ├── title
              ├── description
              ├── isCompleted
              ├── createdAt
              ├── updatedAt
              └── sortIndex
```

Notlar düz metin olarak kaydedilir (şifreleme yok). Eski şifreli kayıtlar (`ciphertext`, `payload`) artık okunmaz; Firestore'dan silip yeniden ekleyin.

## Debug Steps

1. **Logları kontrol et** - Flutter console'da `DEBUG:` yazısı aranacak
2. **Firestore console'da veri var mı kontrol et** - users/{senin_uid}/todos
3. **Authentication** - Firebase Console → Authentication → kullanıcının uid'sini kontrol et

## Permission Denied Hatası

Eğer `permission-denied` hatası alıyorsan:
1. Firebase Console → Firestore Database → Rules sekmesi
2. Kuralları test et: "Test Rules" butonunun altında
