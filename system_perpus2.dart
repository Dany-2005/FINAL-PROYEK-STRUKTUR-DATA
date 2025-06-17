import 'dart:io';
import 'dart:collection';

class Buku {
  String judul;
  int stok;

  Buku(this.judul, this.stok);
}

List<Buku> daftarBuku = []; // List untuk menyimpan semua buku
Map<String, Buku> indeksBuku = {}; // Map untuk pencarian cepat berdasarkan judul
Queue<String> antreanPeminjam = Queue(); // Queue untuk daftar antrean peminjam buku kosong
List<String> historiPinjam = []; // Stack (pakai List) untuk menyimpan histori peminjaman terakhir

void main() {
  while (true) {
    print('\n-> SISTEM PERPUSTAKAAN 4 STRUKTUR DATA <-');
    print('1. Tambah Buku');
    print('2. Daftar Buku');
    print('3. Cari Buku');
    print('4. Pinjam Buku');
    print('5. Kembalikan Buku');
    print('6. Tampilkan Histori Pinjam');
    print('7. Keluar');

    stdout.write('\nPilih Menu (1-7): ');
    String? input = stdin.readLineSync();

    switch (input) {
      case '1':
        tambahBuku();
        break;
      case '2':
        tampilkanDaftarBuku();
        break;
      case '3':
        cariBuku();
        break;
      case '4':
        pinjamBuku();
        break;
      case '5':
        kembalikanBuku();
        break;
      case '6':
        tampilkanHistoriPinjam();
        break;
      case '7':
        print('Terimakasih!');
        return;
      default:
        print('Pilihan tidak valid.');
    }
  }
}

void tambahBuku() {
  stdout.write('\nJudul Buku: ');
  String? judul = stdin.readLineSync();
  stdout.write('Jumlah Stok: ');
  int stok = int.parse(stdin.readLineSync()!);

  if (indeksBuku.containsKey(judul)) {
    indeksBuku[judul]!.stok += stok;
    print('Stok buku diperbarui.');
  } else {
    var bukuBaru = Buku(judul!, stok);
    daftarBuku.add(bukuBaru);
    indeksBuku[judul] = bukuBaru;
    print('Buku berhasil ditambahkan.');
  }
}

void tampilkanDaftarBuku() {
  if (daftarBuku.isEmpty) {
    print('Belum ada buku.');
  } else {
    print('\n-> Daftar Buku <-');
    for (var buku in daftarBuku) {
      print('${buku.judul} (Stok: ${buku.stok})');
    }
  }
}

void cariBuku() {
  stdout.write('\nMasukkan Judul Buku: ');
  String? judul = stdin.readLineSync();

  if (indeksBuku.containsKey(judul)) {
    var buku = indeksBuku[judul]!;
    print('Buku ditemukan! (${buku.judul}) - Stok: ${buku.stok}');
  } else {
    print('Buku tidak ditemukan.');
  }
}

void pinjamBuku() {
  stdout.write('\nMasukkan Judul Buku: ');
  String? judul = stdin.readLineSync();

  if (indeksBuku.containsKey(judul)) {
    var buku = indeksBuku[judul]!;
    if (buku.stok > 0) {
      buku.stok--;
      historiPinjam.add(judul!); // Simpan histori pinjam (stack)
      print('Buku "$judul" berhasil dipinjam.');
    } else {
      stdout.write('Buku habis, masukkan nama untuk antrean: ');
      String? nama = stdin.readLineSync();
      antreanPeminjam.add(nama!);
      print('Ditambahkan ke antrean.');
    }
  } else {
    print('Buku tidak ditemukan.');
  }
}

void kembalikanBuku() {
  stdout.write('\nMasukkan Judul Buku yang Dikembalikan: ');
  String? judul = stdin.readLineSync();

  if (indeksBuku.containsKey(judul)) {
    var buku = indeksBuku[judul]!;
    buku.stok++;
    print('Buku "$judul" berhasil dikembalikan.');

    if (antreanPeminjam.isNotEmpty) {
      String nextPeminjam = antreanPeminjam.removeFirst();
      buku.stok--;
      historiPinjam.add(judul!);
      print('buku $judul langsung di pinjam oleh $nextPeminjam .');
    }
  } else {
    print('Buku tidak ditemukan di perpustakaan.');
  }
}

void tampilkanHistoriPinjam() {
  if (historiPinjam.isEmpty) {
    print('Belum ada histori peminjaman.');
  } else {
    print('\n-> Histori Peminjaman Buku <-');
    for (var item in historiPinjam.reversed) {
      print(item);
    }
  }
}