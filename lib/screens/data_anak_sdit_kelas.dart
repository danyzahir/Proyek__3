import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_screen.dart';
import 'absensi.dart';
import 'nilai.dart';
import 'data_guru_anak.dart';
import 'login.dart';
import 'rekap_absensi.dart';

class DataAnakSDITKelas extends StatefulWidget {
  final String username;
  final String kelas;

  const DataAnakSDITKelas({
    super.key,
    required this.username,
    required this.kelas,
  });

  @override
  State<DataAnakSDITKelas> createState() => _DataAnakSDITKelasState();
}

class _DataAnakSDITKelasState extends State<DataAnakSDITKelas> {
  List<Map<String, String>> siswa = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSiswaByKelas();
  }

  Future<void> fetchSiswaByKelas() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('anak_sdit')
          .where('kelas', isEqualTo: widget.kelas)
          .get();

      final List<Map<String, String>> dataAnak = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'nama': data['nama']?.toString() ?? '',
          'kelas': data['kelas']?.toString() ?? '',
        };
      }).toList();

      setState(() {
        siswa = dataAnak;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching siswa: $e");
      setState(() {
        isLoading = false;
      });
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
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          _buildTableHeader(screenWidth),
                          for (int i = 0; i < siswa.length; i++)
                            _buildRow(
                              i,
                              siswa[i]['nama']!,
                              siswa[i]['kelas']!,
                              screenWidth,
                            ),
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
            "Data Anak - SDIT (Kelas ${widget.kelas})",
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
            _buildHeaderCell('Kelas', screenWidth, flex: 4),
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

  Widget _buildRow(int index, String nama, String kelas, double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.vertical(
          bottom: index == siswa.length - 1
              ? const Radius.circular(10)
              : Radius.zero,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
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
                nama,
                style: TextStyle(fontSize: screenWidth * 0.035),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: Text(
                kelas,
                style: TextStyle(fontSize: screenWidth * 0.035),
              ),
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
              AbsensiScreen(username: widget.username), false, screenWidth),
          _navItem(context, "Nilai", Icons.my_library_books_rounded,
              NilaiScreen(username: widget.username), false, screenWidth),
          _navItem(context, "Data Guru & Anak", Icons.person,
              DataScreen(username: widget.username), true, screenWidth),
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
              context, MaterialPageRoute(builder: (context) => page));
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
