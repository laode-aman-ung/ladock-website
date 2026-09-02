# Status

Diperbarui: 2026-09-02 — PC Ubuntu 24 (`arga`)

## Sedang dikerjakan

Repo baru. Baseline diambil dari situs live 2026-09-02, karena server lebih
baru daripada salinan di repo produk.

## Verifikasi server: LULUS (2026-09-02)

`scripts/snapshot-server.sh` dijalankan terhadap
`root@148.230.103.166:/var/www/ladock`. Hasilnya bersih di ketiga daftar:

```
On the server but NOT in this repo   : (none)
In this repo but not on the server   : (none)
Present in both but DIFFERENT        : (none)
```

Sembilan berkas di server — LICENSE, citation/docs/features/index/pricing.html,
style.css, main.js, ladock_viewer.png — semuanya sudah ada di repo dengan isi
identik. Repo terbukti lengkap, deploy aman dijalankan.

Catatan: server ini juga menjalankan `osce.ladeep.id` dari
`/opt/osce/frontend/dist`. Itu sebabnya `deploy.sh` menolak berjalan bila
`index.html` tidak ditemukan di path tujuan — salah path dengan `rsync
--delete` sebagai root akan menghapus proyek lain.

## Langkah berikutnya

1. Selesaikan perbedaan LICENSE (lihat bawah).
2. Pertimbangkan berhenti deploy sebagai root; buat pengguna khusus yang
   hanya berhak menulis ke `/var/www/ladock`. Kunci root saat ini memberi
   akses penuh ke seluruh server, termasuk proyek OSCE yang tidak
   berhubungan.

## Tertunda / macet

- **Dua teks LICENSE yang berbeda beredar publik.** Situs menyajikan
  "LADOCK Desktop Software License, Copyright (c) 2024" (4.323 byte),
  sedangkan repo produk `LADOCK` memuat teks lain. Keduanya publik. Untuk
  produk berlisensi komersial ini perlu diseragamkan — salinan yang ada di
  repo ini diambil apa adanya dari server agar deploy tidak mengubah apa yang
  sedang tayang, bukan karena sudah dinyatakan benar.
- `deploy.conf` sudah dibuat di mesin ini (diabaikan git). Mesin kedua perlu
  membuatnya sendiri: `LADOCK_WEB_HOST=root@148.230.103.166`,
  `LADOCK_WEB_PATH=/var/www/ladock`.
- `downloads/` sudah kosong di server (installer 404). Tautan unduhan versi
  live sudah menunjuk GitHub Releases, jadi tidak ada yang perlu diselamatkan.

## Keputusan terakhir

- 2026-09-02 — Situs dipisahkan ke repo sendiri, publik. Alasannya irama
  rilis dan target deploy berbeda dari repo produk, dan keadaan sebelumnya
  (3 dari 7 berkas terlacak di `LADOCK`, sisanya tidak di mana pun)
  meninggalkan `style.css` tanpa versi sama sekali.
- 2026-09-02 — Alur ditetapkan satu arah: repo → server.
- 2026-09-02 — Deploy dikunci di balik verifikasi snapshot lebih dulu.
