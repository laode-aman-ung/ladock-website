# Status

Diperbarui: 2026-09-02 — PC Ubuntu 24 (`arga`)

## Sedang dikerjakan

Tidak ada yang tergantung. Repo bersih, terdorong, dan **isinya sama persis
dengan yang tayang** di ladock.ladeep.id — deploy terakhir dijalankan setelah
perubahan terakhir.

## Yang berubah hari ini

- Situs kini menampilkan LADOCK sebagai **satu produk dua mode**. Sebelumnya
  "LADOCK Desktop" di 14 tempat dan CLI tidak disebut sama sekali — nol
  kemunculan `ladock-cli` di kelima halaman, padahal kampanye pengujian 2026
  justru menguji front-end itu.
- `docs.html` dapat bagian CLI penuh dengan entri sidebar, diambil dari
  `docs/cli.md` di repo produk. `features.html` dapat blok dua front-end.
- Tombol Download hidup, membuka tab baru, menunjuk `releases/latest`.
- Batas gratis dikoreksi dari **2030 ke 2029** di 13 tempat. Situs menjanjikan
  setahun lebih lama daripada yang perangkat lunaknya izinkan.
- `LICENSE` kini byte-identik dengan repo produk, memuat Surat Pencatatan
  Ciptaan No. 001413018. Versi lama di server membatasi lisensi gratis hanya
  untuk akademisi dengan email institusi terverifikasi — syarat yang tidak
  pernah ada di perangkat lunaknya.
- `deploy.sh` diperkuat: menolak jalan bila `index.html` tidak ditemukan di
  path tujuan, menampilkan pratinjau, `-n` untuk uji kering, `-y` untuk
  non-interaktif, dan `ssh -n` agar ssh tidak menelan jawaban konfirmasi.

## Verifikasi server (2026-09-02)

`scripts/snapshot-server.sh` dijalankan terhadap
`root@148.230.103.166:/var/www/ladock`. Ketiga daftar bersih — tidak ada
berkas di server yang tidak ada di repo, dan sebaliknya.

Catatan: host ini juga menjalankan `osce.ladeep.id` dari
`/opt/osce/frontend/dist`. Itu sebabnya `deploy.sh` menolak berjalan pada path
yang tidak dikenalinya — salah path dengan `rsync --delete` sebagai root akan
menghapus proyek lain.

## Langkah berikutnya

1. Pertimbangkan berhenti deploy sebagai `root`. Buat pengguna khusus yang
   hanya berhak menulis ke `/var/www/ladock`; kunci root saat ini memberi
   akses penuh ke seluruh server.
2. Bila kelak ada rilis baru yang membawa installer, pastikan dibuat sebagai
   rilis biasa — bukan pre-release — agar `releases/latest` ikut berpindah dan
   tombol Download menunjuk yang benar.

## Tertunda / macet

- `deploy.conf` hanya ada di mesin ini (diabaikan git). Mesin kedua perlu
  membuatnya sendiri: `LADOCK_WEB_HOST=root@148.230.103.166`,
  `LADOCK_WEB_PATH=/var/www/ladock`.
- `/var/www/ladock/bin/` di server berisi arsip engine 187 MB yang diambil CI
  lewat secret `LADOCK_BIN_BASE_URL`. Ada di dalam document root tapi bukan
  bagian repo ini; `deploy.sh` mengecualikannya agar `--delete` tidak
  menghapusnya.

## Keputusan terakhir

- 2026-09-02 — Alur satu arah: repo → server. Sebelum repo ini ada, suntingan
  dilakukan langsung di nginx, dan `docs.html` di server menyimpang selama
  berbulan-bulan.
- 2026-09-02 — Baseline diambil dari situs live, bukan dari salinan di repo
  produk yang sudah basi.
