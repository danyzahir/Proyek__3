import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'absensi.dart';
import 'nilai.dart';
import 'data_guru_anak.dart';
import 'login.dart';
import 'rekap_absensi.dart';

class NilaiEditScreen extends StatefulWidget {
  final String username;
  final String namaKelas;

  const NilaiEditScreen({
    super.key,
    required this.username,
    required this.namaKelas,
  });

  @override
  State<NilaiEditScreen> createState() => _NilaiEditScreen();
}

class _NilaiEditScreen extends State<NilaiEditScreen> {
  final List<Map<String, dynamic>> siswa = [
    {'nama': 'Abdul', 'uts': '', 'uas': ''},
    {'nama': 'Adnan', 'uts': '', 'uas': ''},
    {'nama': 'Bule', 'uts': '', 'uas': ''},
    {'nama': 'Candi', 'uts': '', 'uas': ''},
  ];

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
              Container(
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
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
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
              ),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black54,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                        ),
                        onPressed: () {
                          // Simpan logika penyimpanan data di sini (misalnya ke backend atau database)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data nilai berhasil disimpan!'),
                            ),
                          );
                        },
                        child: const Text(
                          'SIMPAN',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
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
                    ),
                    for (int i = 0; i < siswa.length; i++)
                      _buildInputRow(i, screenWidth),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
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
      ),
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

  Widget _buildInputRow(int index, double screenWidth) {
    final data = siswa[index];
    return Container(
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.vertical(
          bottom: index == siswa.length - 1
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
                "${index + 1}",
                style: TextStyle(fontSize: screenWidth * 0.035),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                data['nama'],
                style: TextStyle(fontSize: screenWidth * 0.035),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: SizedBox(
                width: screenWidth * 0.12,
                child: TextFormField(
                  initialValue: data['uts'],
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      siswa[index]['uts'] = value;
                    });
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: screenWidth * 0.035),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: SizedBox(
                width: screenWidth * 0.12,
                child: TextFormField(
                  initialValue: data['uas'],
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      siswa[index]['uas'] = value;
                    });
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: screenWidth * 0.035),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                _hitungRataRata(data),
                style: TextStyle(fontSize: screenWidth * 0.035),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _hitungRataRata(Map<String, dynamic> data) {
    try {
      double uts = double.tryParse(data['uts']) ?? 0.0;
      double uas = double.tryParse(data['uas']) ?? 0.0;
      if (data['uts'].toString().isEmpty && data['uas'].toString().isEmpty) {
        return '';
      }
      return ((uts + uas) / 2).toStringAsFixed(1);
    } catch (_) {
      return '';
    }
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
}
