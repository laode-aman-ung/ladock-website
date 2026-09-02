# Status

Diperbarui: 2026-09-02 — PC Ubuntu 24 (`arga`)

## Sedang dikerjakan

Repo baru. Baseline diambil dari situs live 2026-09-02, karena server lebih
baru daripada salinan di repo produk.

## ⛔ Jangan deploy dulu

`scripts/deploy.sh` memakai `rsync --delete` dan repo ini **belum terbukti
lengkap**. Isinya dikumpulkan dengan menebak nama berkas lewat HTTP, cara yang
tidak bisa melihat berkas yang tidak ditautkan dari halaman mana pun. Satu
sudah kecolongan dengan cara itu (`LICENSE`), jadi mungkin ada yang lain.

Urutan wajib sebelum deploy pertama:

1. Isi `deploy.conf` — cari document root yang benar di server:
   `ssh 148.230.103.166 "grep -r 'root ' /etc/nginx/sites-enabled/"`
2. Jalankan `scripts/snapshot-server.sh` — hanya membaca, tidak menulis
   apa pun ke server. Menampilkan tiga daftar: ada di server tapi tidak di
   repo, ada di repo tapi tidak di server, dan yang berbeda isinya.
3. Commit apa pun yang muncul di daftar pertama. Itu yang akan **terhapus**
   kalau deploy dijalankan sekarang.
4. Baru `scripts/deploy.sh -n`, lalu tanpa `-n`.

## Langkah berikutnya

1. Kerjakan empat langkah di atas.
2. Selesaikan perbedaan LICENSE (lihat bawah).
3. Buat kunci SSH agar deploy tidak meminta kata sandi tiap kali:
   `ssh-keygen -t ed25519 && ssh-copy-id root@148.230.103.166`
4. Pertimbangkan berhenti deploy sebagai root; buat pengguna khusus yang
   hanya berhak menulis ke document root.

## Tertunda / macet

- **Dua teks LICENSE yang berbeda beredar publik.** Situs menyajikan
  "LADOCK Desktop Software License, Copyright (c) 2024" (4.323 byte),
  sedangkan repo produk `LADOCK` memuat teks lain. Keduanya publik. Untuk
  produk berlisensi komersial ini perlu diseragamkan — salinan yang ada di
  repo ini diambil apa adanya dari server agar deploy tidak mengubah apa yang
  sedang tayang, bukan karena sudah dinyatakan benar.
- Host dan path server belum tercatat; `deploy.conf` belum dibuat.
- `downloads/` sudah kosong di server (installer 404). Tautan unduhan versi
  live sudah menunjuk GitHub Releases, jadi tidak ada yang perlu diselamatkan.

## Keputusan terakhir

- 2026-09-02 — Situs dipisahkan ke repo sendiri, publik. Alasannya irama
  rilis dan target deploy berbeda dari repo produk, dan keadaan sebelumnya
  (3 dari 7 berkas terlacak di `LADOCK`, sisanya tidak di mana pun)
  meninggalkan `style.css` tanpa versi sama sekali.
- 2026-09-02 — Alur ditetapkan satu arah: repo → server.
- 2026-09-02 — Deploy dikunci di balik verifikasi snapshot lebih dulu.
