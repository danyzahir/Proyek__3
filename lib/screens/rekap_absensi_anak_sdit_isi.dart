import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyek3/screens/rekap_absensi.dart';
import 'absensi.dart';
import 'home_screen.dart';
import 'nilai.dart';
import 'data_guru_anak.dart';
import 'login.dart';

// Tambahan import untuk PDF dan Printing
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class RekapAbsenAnakSDIT extends StatelessWidget {
  final String username;
  final String namaKelas;

  const RekapAbsenAnakSDIT({
    super.key,
    required this.username,
    required this.namaKelas,
  });

  // Fungsi bantu ekstrak kode kelas dari "KELAS A" -> "A"
  String _extractKelas(String kelasLengkap) {
    final parts = kelasLengkap.split(' ');
    if (parts.length >= 2) {
      return parts[1];
    }
    return kelasLengkap;
  }

  // Fungsi untuk generate dan tampilkan PDF rekap absensi
  Future<void> _generatePdf(BuildContext context, Map<String, Map<String, int>> rekap) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Rekap Absensi $namaKelas",
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),

              pw.Table.fromTextArray(
                headers: ['No', 'Nama Siswa', 'Hadir', 'Izin', 'Sakit', 'Alpa'],
                data: List.generate(rekap.length, (index) {
                  final nama = rekap.keys.elementAt(index);
                  final data = rekap[nama]!;
                  return [
                    '${index + 1}',
                    nama,
                    data['HADIR'].toString(),
                    data['IZIN'].toString(),
                    data['SAKIT'].toString(),
                    data['ALPA'].toString(),
                  ];
                }),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.green,
                ),
                cellAlignment: pw.Alignment.center,
                cellStyle: const pw.TextStyle(fontSize: 10),
                border: pw.TableBorder.all(color: PdfColors.grey),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Hijau
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 45),
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'logout') {
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                  (route) => false,
                                );
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'logout',
                                child: Row(
                                  children: [
                                    Icon(Icons.logout, color: Colors.red),
                                    SizedBox(width: 10),
                                    Text('Logout'),
                                  ],
                                ),
                              ),
                            ],
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 18,
                              child: Icon(Icons.person, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "REKAP ABSEN $namaKelas",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "BULAN",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Firebase Data
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('sdit_absen')
                    .where('kelas', isEqualTo: _extractKelas(namaKelas))
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text("Tidak ada data absensi tersedia.");
                  }

                  final docs = snapshot.data!.docs;

                  // Hitung rekap absensi berdasarkan nama
                  Map<String, Map<String, int>> rekap = {};

                  for (var doc in docs) {
                    final data = doc.data() as Map<String, dynamic>;
                    final nama = data['nama'] ?? 'Tidak diketahui';
                    final absen = data['absen'] ?? '';

                    if (!rekap.containsKey(nama)) {
                      rekap[nama] = {
                        'HADIR': 0,
                        'IZIN': 0,
                        'SAKIT': 0,
                        'ALPA': 0,
                      };
                    }

                    switch (absen) {
                      case 'H':
                        rekap[nama]!['HADIR'] = rekap[nama]!['HADIR']! + 1;
                        break;
                      case 'I':
                        rekap[nama]!['IZIN'] = rekap[nama]!['IZIN']! + 1;
                        break;
                      case 'S':
                        rekap[nama]!['SAKIT'] = rekap[nama]!['SAKIT']! + 1;
                        break;
                      case 'A':
                        rekap[nama]!['ALPA'] = rekap[nama]!['ALPA']! + 1;
                        break;
                    }
                  }

                  final siswaList = rekap.keys.toList();

                  return Column(
                    children: [
                      ...List.generate(siswaList.length, (index) {
                        final nama = siswaList[index];
                        final data = rekap[nama]!;

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ExpansionTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            tilePadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            childrenPadding: const EdgeInsets.only(
                                left: 20, right: 12, bottom: 12),
                            title: Row(
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    "${index + 1}.",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    nama,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text("HADIR = ${data['HADIR']} Hari"),
                                    const SizedBox(height: 4),
                                    Text("IZIN = ${data['IZIN']} Hari"),
                                    const SizedBox(height: 4),
                                    Text("SAKIT = ${data['SAKIT']} Hari"),
                                    const SizedBox(height: 4),
                                    Text("ALPA = ${data['ALPA']} Hari"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 15),

                      // Tombol Export ke PDF
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _generatePdf(context, rekap);
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Export ke PDF'),
                        style:
                            ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),

                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(context, "Dashboard", Icons.home,
                HomeScreen(username: username), false),
            _navItem(context, "Absensi", Icons.assignment_ind_rounded,
                AbsensiScreen(username: username), false),
            _navItem(context, "Nilai", Icons.my_library_books_rounded,
                NilaiScreen(username: username), false),
            _navItem(context, "Data Siswa & Guru", Icons.person,
                DataScreen(username: username), false),
            _navItem(context, "Rekap Absensi", Icons.receipt_long,
                RekapScreen(username: username), true),
          ],
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, String title, IconData icon,
      Widget page, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 26, color: isActive ? Colors.green : Colors.black54),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.green : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
