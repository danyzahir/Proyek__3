import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:proyek3/screens/rekap_absensi.dart';
import 'absensi.dart';
import 'home_screen.dart';
import 'nilai.dart';
import 'data_guru_anak.dart';
import 'login.dart';

class RekapAbsenGuruSDIT extends StatelessWidget {
  final String username;

  const RekapAbsenGuruSDIT({super.key, required this.username});

  Future<Map<String, Map<String, int>>> fetchRekapAbsen() async {
    final snapshot = await FirebaseFirestore.instance.collection('absensi_guru').get();
    Map<String, Map<String, int>> rekap = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final nama = data['nama'];
      final status = data['status'];

      if (!rekap.containsKey(nama)) {
        rekap[nama] = {'H': 0, 'I': 0, 'S': 0, 'A': 0};
      }
      if (rekap[nama]!.containsKey(status)) {
        rekap[nama]![status] = rekap[nama]![status]! + 1;
      }
    }
    return rekap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: FutureBuilder<Map<String, Map<String, int>>>(
        future: fetchRekapAbsen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final rekap = snapshot.data ?? {};
          final guruList = rekap.keys.toList();

          return SingleChildScrollView(
            child: Column(
              children: [
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
                              Text(username, style: const TextStyle(fontSize: 16, color: Colors.white)),
                              const SizedBox(width: 10),
                              PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'logout') {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                      const Text(
                        "REKAP ABSEN GURU SDIT",
                        style: TextStyle(
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: List.generate(guruList.length, (index) {
                      final nama = guruList[index];
                      final absen = rekap[nama]!;
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ExpansionTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          childrenPadding: const EdgeInsets.only(left: 20, right: 12, bottom: 12),
                          title: Row(
                            children: [
                              SizedBox(
                                width: 40,
                                child: Text(
                                  "${index + 1}.",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  nama,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("HADIR = ${absen['H']} Hari"),
                                  Text("IZIN = ${absen['I']} Hari"),
                                  Text("SAKIT = ${absen['S']} Hari"),
                                  Text("ALPA = ${absen['A']} Hari"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
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
            _navItem(context, "Dashboard", Icons.home, HomeScreen(username: username), false),
            _navItem(context, "Absensi", Icons.assignment_ind_rounded, AbsensiScreen(username: username), false),
            _navItem(context, "Nilai", Icons.my_library_books_rounded, NilaiScreen(username: username), false),
            _navItem(context, "Data Siswa & Guru", Icons.person, DataScreen(username: username), false),
            _navItem(context, "Rekap Absensi", Icons.receipt_long, RekapScreen(username: username), true),
          ],
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, String title, IconData icon, Widget page, bool isActive) {
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
