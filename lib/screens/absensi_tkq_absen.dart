import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'absensi.dart';
import 'home_screen.dart';
import 'nilai.dart';
import 'data_guru_anak.dart';
import 'login.dart';
import 'rekap_absensi.dart';

class AbsensiTKQAbsen extends StatefulWidget {
  final String username;
  final String kelas;

  const AbsensiTKQAbsen(
      {super.key, required this.username, required this.kelas});

  @override
  State<AbsensiTKQAbsen> createState() => _AbsensiTKQAbsenState();
}

class _AbsensiTKQAbsenState extends State<AbsensiTKQAbsen> {
  List<String> siswa = [];
  bool isLoading = true;
  final Map<int, String> pilihanAbsensi = {};

  @override
  void initState() {
    super.initState();
    fetchSiswa();
  }

  Future<void> fetchSiswa() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('anak_sdit')
          .where('kelas', isEqualTo: widget.kelas)
          .get();

      final List<String> namaSiswa =
          snapshot.docs.map((doc) => doc['nama'] as String).toList();

      setState(() {
        siswa = namaSiswa;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching siswa: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> simpanAbsensiKeFirebase() async {
    try {
      final tanggalSekarang = DateTime.now();

      for (int i = 0; i < siswa.length; i++) {
        if (pilihanAbsensi.containsKey(i)) {
          await FirebaseFirestore.instance.collection('sdit_absen').add({
            'nama': siswa[i],
            'absen': pilihanAbsensi[i],
            'tanggal': tanggalSekarang,
            'kelas': widget.kelas,
          });
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Absensi berhasil disimpan")),
      );
    } catch (e) {
      print("Gagal menyimpan absensi: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyimpan absensi")),
      );
    }
  }

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
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          _buildTableHeader(screenWidth),
                          for (int i = 0; i < siswa.length; i++)
                            _buildRow(i, siswa[i], screenWidth),
                        ],
                      ),
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton(
                onPressed: () async {
                  await simpanAbsensiKeFirebase();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'SIMPAN',
                  style: TextStyle(color: Colors.black),
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
                            builder: (context) => const LoginScreen(),
                          ),
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
            "${widget.kelas}",
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
            _buildHeaderCell('NamaAnak', screenWidth, flex: 3),
            _buildHeaderCell('Pilihan', screenWidth, flex: 4),
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

  Widget _buildRow(int index, String name, double screenWidth) {
    return Container(
      color: index % 2 == 0 ? Colors.white : Colors.grey[100],
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "${index + 1}.",
                style: TextStyle(fontSize: screenWidth * 0.035),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                name,
                style: TextStyle(fontSize: screenWidth * 0.035),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['H', 'A', 'I', 'S']
                  .map((e) => GestureDetector(
                        onTap: () {
                          setState(() {
                            pilihanAbsensi[index] = e;
                          });
                        },
                        child: CircleAvatar(
                          radius: screenWidth * 0.04,
                          backgroundColor: pilihanAbsensi[index] == e
                              ? Colors.green
                              : Colors.grey[300],
                          child: Text(
                            e,
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: pilihanAbsensi[index] == e
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
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
              AbsensiScreen(username: widget.username), true, screenWidth),
          _navItem(context, "Nilai", Icons.my_library_books_rounded,
              NilaiScreen(username: widget.username), false, screenWidth),
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
}
