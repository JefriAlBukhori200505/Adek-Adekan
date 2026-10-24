# MOJEK

Aplikasi ojek online untuk mahasiswa (prototipe Flutter). Penumpang memesan
perjalanan dengan memilih titik di peta; driver melihat titik jemput dan
menjalankan perjalanan. Seluruh data masih tersimpan di perangkat (Hive).

## Menjalankan

```bash
flutter pub get
flutter run
flutter test
```

Android memakai `applicationId = com.mojek.app`. Izin lokasi dan internet
sudah ditambahkan di manifest Android dan Info.plist iOS.

## Fitur

| Area | Isi |
|---|---|
| Akun | Daftar/masuk (penumpang atau driver), sesi tersimpan, keluar |
| Profil | Edit profil per peran (NIM/kampus; motor/plat/SIM), avatar inisial |
| Peta | OpenStreetMap, pilih titik dengan geser peta, GPS, lokasi kampus, favorit |
| Pesan | Tarif berdasarkan jarak, diskon mahasiswa 10% (bila NIM terisi), metode bayar |
| Pelacakan | Posisi driver di peta, ETA, status langkah demi langkah |
| Chat | Penumpang–driver per pesanan |
| Pembatalan | Penumpang batal sebelum dijemput; driver tolak/lepas pesanan |
| Rating | Bintang + ulasan setelah perjalanan selesai |
| Driver | Online/offline, pesanan masuk (Prioritas dulu), pendapatan 7 hari |
| Lainnya | Notifikasi dalam aplikasi, bantuan darurat (salin detail), asisten FAQ |

## Struktur `lib/`

```
core/       formatters, validators, geo, fare_calculator, campus_places
models/     enums, place, user_profile, ride_order, chat_message, app_notification
services/   auth, profile, ride_order, chat, notification, location,
            trip_simulator, assistant
widgets/    komponen bersama (tombol, peta, kartu pesanan, dialog, dll.)
screens/    auth/, common/, passenger/, driver/
theme/      app_theme
```

Aturan status pesanan hanya ada di `RideOrderService`; layar hanya menampilkan
hasilnya.

## Batasan yang perlu diketahui

- **Belum ada backend.** Penumpang dan driver berbagi satu penyimpanan di
  perangkat yang sama (ganti peran dengan keluar lalu masuk). Pelacakan live
  dan chat antar-perangkat butuh server realtime.
- **Posisi driver disimulasikan** (`TripSimulator`, garis lurus). Layar hanya
  membaca `positionOf(orderId)`, jadi sumber datanya bisa diganti GPS driver.
- **Koordinat kampus di `core/campus_places.dart` hanya contoh.** Ganti.
- **Tarif memakai jarak garis lurus × 1,3**, bukan rute jalan.
- **Autentikasi lokal** (hash bergaram) hanya untuk demo.
- **E-wallet hanya simulasi**; notifikasi bukan push sungguhan.
- Server tile resmi OpenStreetMap untuk pemakaian ringan; untuk rilis publik
  gunakan penyedia tile sendiri/berbayar.
- Data lama (`mojek_orders`) tidak dimigrasi; pesanan kini di `mojek_orders_v2`.
