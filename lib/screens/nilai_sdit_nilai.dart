import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_screen.dart';
import 'absensi.dart';
import 'nilai.dart';
import 'data_guru_anak.dart';
import 'login.dart';
import 'rekap_absensi.dart';


class NilaiSDITNilai extends StatefulWidget {
  final String username;
  final String namaKelas;

  const NilaiSDITNilai({
    super.key,
    required this.username,
    required this.namaKelas,
  });

  @override
  State<NilaiSDITNilai> createState() => _NilaiSDITNilaiState();
}

class _NilaiSDITNilaiState extends State<NilaiSDITNilai> {
  // Menyimpan nilai UTS dan UAS yang sudah diinput user, key = nama siswa
  Map<String, Map<String, String>> nilaiMap = {};

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black54,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                        ),
                        onPressed: _simpanNilaiKeFirebase,
                        child: const Text(
                          'SIMPAN NILAI',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTableHeader(screenWidth),
                    _buildSiswaList(screenWidth),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(screenHeight, screenWidth),
    );
  }

  Widget _buildHeader(double screenWidth, double screenHeight) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.05,
      ),
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
                    widget.username,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'logout') {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
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
          SizedBox(height: screenHeight * 0.015),
          Text(
            widget.namaKelas,
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(double screenWidth) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      child: Container(
        color: Colors.green[700],
        child: Row(
          children: [
            _buildHeaderCell('No', screenWidth, flex: 1),
            _buildHeaderCell('Nama', screenWidth, flex: 3),
            _buildHeaderCell('UTS', screenWidth, flex: 2),
            _buildHeaderCell('UAS', screenWidth, flex: 2),
            _buildHeaderCell('Rata2', screenWidth, flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildSiswaList(double screenWidth) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('anak_sdit')
          .where('kelas', isEqualTo: '1') // Tampilkan hanya kelas 1
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Tidak ada data siswa kelas 1.'),
          );
        }

        final dataList = snapshot.data!.docs;

        return Column(
          children: List.generate(dataList.length, (index) {
            final data = dataList[index].data() as Map<String, dynamic>;
            final nama = data['nama'] ?? '-';

            // Ambil nilai dari nilaiMap jika sudah ada, atau default ""
            String uts = nilaiMap[nama]?['uts'] ?? '';
            String uas = nilaiMap[nama]?['uas'] ?? '';

            // Hitung rata-rata jika nilai valid
            double? utsVal = double.tryParse(uts);
            double? uasVal = double.tryParse(uas);
            String rata2 = '';
            if (utsVal != null && uasVal != null) {
              rata2 = ((utsVal + uasVal) / 2).toStringAsFixed(2);
            }

            return Container(
              decoration: BoxDecoration(
                color: index % 2 == 0 ? Colors.white : Colors.grey[100],
                borderRadius: BorderRadius.vertical(
                  bottom: index == dataList.length - 1
                      ? const Radius.circular(10)
                      : Radius.zero,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(fontSize: screenWidth * 0.035),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        nama,
                        style: TextStyle(fontSize: screenWidth * 0.035),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: TextFormField(
                        initialValue: uts,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'UTS',
                        ),
                        onChanged: (value) {
                          setState(() {
                            nilaiMap[nama] ??= {};
                            nilaiMap[nama]!['uts'] = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: TextFormField(
                        initialValue: uas,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'UAS',
                        ),
                        onChanged: (value) {
                          setState(() {
                            nilaiMap[nama] ??= {};
                            nilaiMap[nama]!['uas'] = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        rata2,
                        style: TextStyle(fontSize: screenWidth * 0.035),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildHeaderCell(String text, double screenWidth, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(double screenHeight, double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
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
              HomeScreen(username: widget.username), false, screenWidth),
          _navItem(context, "Absensi", Icons.assignment_ind_rounded,
              AbsensiScreen(username: widget.username), false, screenWidth),
          _navItem(context, "Nilai", Icons.my_library_books_rounded,
              NilaiScreen(username: widget.username), true, screenWidth),
          _navItem(context, "Data Guru & Anak", Icons.person,
              DataScreen(username: widget.username), false, screenWidth),
          _navItem(context, "Rekap Absensi", Icons.receipt_long,
              RekapScreen(username: widget.username), false, screenWidth),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, String title, IconData icon,
      Widget page, bool isActive, double screenWidth) {
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
          Icon(icon,
              size: screenWidth * 0.06,
              color: isActive ? Colors.green : Colors.black54),
          SizedBox(height: screenWidth * 0.01),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.025,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.green : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _simpanNilaiKeFirebase() async {
    final batch = FirebaseFirestore.instance.batch();

    nilaiMap.forEach((nama, nilai) {
      double? utsVal = double.tryParse(nilai['uts'] ?? '');
      double? uasVal = double.tryParse(nilai['uas'] ?? '');
      if (utsVal != null && uasVal != null) {
        double rata2 = (utsVal + uasVal) / 2;

        final docRef = FirebaseFirestore.instance
            .collection('nilai_sdit')
            .doc(nama); // dokumen per nama siswa

        batch.set(docRef, {
          'nama': nama,
          'uts': utsVal,
          'uas': uasVal,
          'rata2': rata2,
          'kelas': '1',
        });
      }
    });

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data nilai berhasil disimpan')),
    );
  }
}
