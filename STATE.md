# Status

Diperbarui: 2026-09-02 — PC Ubuntu 24 (`arga`)

## Sedang dikerjakan

Repo baru. Baseline diambil dari situs live pada 2026-09-02, karena server
lebih baru daripada salinan di repo produk.

## Langkah berikutnya

1. Isi `deploy.conf` dengan host dan path nginx, lalu uji `scripts/deploy.sh`
   sekali untuk memastikan rsync-nya benar sebelum diandalkan.
2. Hapus tiga berkas situs yang basi dari repo produk `LADOCK`
   (`website/index.html`, `features.html`, `docs.html`) supaya tidak ada dua
   sumber kebenaran.
3. Pertimbangkan memindahkan installer di `downloads/` ke GitHub Releases —
   `docs.html` sudah menunjuk ke sana.

## Tertunda / macet

- Host dan path server belum tercatat di mana pun; `scripts/deploy.sh` belum
  pernah dijalankan.

## Keputusan terakhir

- 2026-09-02 — Situs dipisahkan ke repo sendiri, publik. Alasannya irama
  rilis dan target deploy berbeda dari repo produk, dan keadaan sebelumnya
  (3 dari 7 berkas terlacak di `LADOCK`, sisanya tidak di mana pun)
  meninggalkan `style.css` tanpa versi sama sekali.
- 2026-09-02 — Alur ditetapkan satu arah: repo → server.
