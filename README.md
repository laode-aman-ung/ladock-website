# ladock-website

Situs LADOCK, live di **https://ladock.ladeep.id** — dilayani nginx pada
server sendiri, bukan GitHub Pages.

Situs statis: 7 halaman HTML, satu stylesheet, satu berkas JS, satu gambar.
Tidak ada proses build.

## Menyunting

```bash
git pull
# sunting berkas .html / .css / .js
scripts/deploy.sh
```

**Jangan pernah menyunting langsung di server.** Repositori ini sumber
kebenaran, server hanya salinan.

## Deploy

Konfigurasi sekali, lewat variabel lingkungan atau `deploy.conf`
(diabaikan git):

```bash
LADOCK_WEB_HOST=user@host
LADOCK_WEB_PATH=/var/www/ladock
```

```bash
scripts/deploy.sh
```

Skrip memakai `rsync --delete` agar server persis sama dengan repo, tetapi
`downloads/` dikecualikan supaya installer yang sudah ada di server tidak
ikut terhapus.

## Repositori terkait

| Repo | Status | Isi |
|---|---|---|
| `laode-aman-ung/ladock` | publik | Produk: `ladock-cli` + `ladock-desktop` |
| `laode-aman-ung/ladock-riset` | privat | HKI, naskah, luaran, pengujian |
| `laode-aman-ung/ladock-website` | publik | repo ini |
