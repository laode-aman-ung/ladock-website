# CLAUDE.md — ladock-website

Situs statis LADOCK, live di https://ladock.ladeep.id.

## Sifat proyek

Tanpa build, tanpa framework, tanpa dependensi. Tujuh berkas HTML/CSS/JS yang
disalin apa adanya ke nginx. Jangan menambahkan bundler, generator statis,
atau dependensi npm tanpa alasan yang kuat — nilai utama repo ini adalah
kesederhanaannya.

```
index.html      halaman utama
features.html   fitur
docs.html       unduhan dan dokumentasi
pricing.html    harga
citation.html   cara mensitasi
style.css       seluruh tampilan situs
main.js         interaksi kecil
ladock_viewer.png  gambar utama
scripts/deploy.sh  rsync ke nginx
```

## Aturan mutlak: satu arah

Repo → server, tidak pernah sebaliknya. Sebelum repo ini ada, suntingan
dilakukan langsung di nginx; akibatnya `docs.html` di server menyimpang dari
salinan di repo produk selama berbulan-bulan, dan `style.css`, `main.js`,
`pricing.html`, `citation.html` tidak pernah terversi sama sekali.

Baseline repo ini diambil dari **versi live** pada 2026-09-02, bukan dari
salinan lokal yang sudah basi.

## Hal yang perlu diketahui

1. **Repo ini publik.** Tidak boleh memuat dokumen HKI, naskah, data hibah,
   atau kredensial. Semua itu ada di `ladock-riset` yang privat.
2. `downloads/` tidak masuk git. Installer dilayani dari server atau, lebih
   baik, dari GitHub Releases — `docs.html` versi live sudah menunjuk ke sana.
3. `bin/` di server berisi arsip engine (187 MB) yang diambil CI lewat
   `LADOCK_BIN_BASE_URL`. Ada di dalam document root tapi **bukan** bagian
   repo ini; `deploy.sh` mengecualikannya agar `rsync --delete` tidak
   menghapusnya.
4. Tautan unduhan pernah menunjuk `LADOCK-2.0.0-*` di `downloads/`, penomoran
   desktop lama yang sudah ditinggalkan. Versi live sudah dikoreksi ke
   GitHub Releases; jangan dikembalikan.
5. `deploy.conf` berisi host dan path server. Diabaikan git — jangan
   di-commit.

## Aturan sesi

### Awal sesi
1. `git pull` sebelum melakukan apa pun.
2. Baca `STATE.md`.
3. Ringkas dalam 2–3 kalimat di mana pekerjaan terhenti.
4. Jangan mulai sebelum saya konfirmasi arahnya.

### Akhir sesi
1. Perbarui `STATE.md` dengan tanggal dan nama mesin.
2. Tampilkan daftar berkas yang akan di-commit, tunggu persetujuan.
3. Commit, push, lalu ingatkan saya menjalankan `scripts/deploy.sh` bila
   perubahannya perlu tayang.

### Sepanjang sesi
- Bahasa Indonesia untuk penjelasan, Inggris untuk komentar kode dan pesan
  commit.
- Jangan pernah menyunting langsung di server.
