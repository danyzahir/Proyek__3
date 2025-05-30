import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login.dart';
import 'absensi.dart';
import 'nilai.dart';
import 'data_guru_anak.dart';
import 'rekap_absensi.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: Column(
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
                    Image.asset('images/icon.png', height: screenHeight * 0.06),
                    Row(
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.white),
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
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            radius: 18,
                            child:
                                const Icon(Icons.person, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                const Text(
                  "DASHBOARD",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Agenda Terdekat",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('agenda')
                  .orderBy('tanggal', descending: false)
                  .limit(1)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text("Tidak ada agenda.");
                }

                final data =
                    snapshot.data!.docs.first.data() as Map<String, dynamic>;
                final DateTime tanggal =
                    (data['tanggal'] as Timestamp).toDate();
                final String tanggalStr =
                    "${tanggal.day.toString().padLeft(2, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.year}";
                final String judul = data['nama'] ?? "Tanpa Judul";

                return Container(
                  padding: EdgeInsets.all(screenWidth * 0.035),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: Colors.black54, size: screenWidth * 0.04),
                      SizedBox(width: screenWidth * 0.025),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tanggalStr,
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            judul,
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: SingleChildScrollView(
                child: Center(
                  child: Wrap(
                    spacing: screenWidth * 0.04,
                    runSpacing: screenHeight * 0.02,
                    alignment: WrapAlignment.center,
                    children: [
                      _menuItem(context, "Absensi", Icons.people_alt, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AbsensiScreen(username: username),
                          ),
                        );
                      }, screenWidth),
                      _menuItem(context, "Nilai", Icons.school, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NilaiScreen(username: username),
                          ),
                        );
                      }, screenWidth),
                      _menuItem(context, "Data Siswa & Guru", Icons.person, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DataScreen(username: username),
                          ),
                        );
                      }, screenWidth),
                      _menuItem(context, "Rekap Absensi", Icons.receipt_long,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RekapScreen(username: username),
                          ),
                        );
                      }, screenWidth),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          Text(
            "© 2024 Powered by Nahdlatut Tujjar",
            style:
                TextStyle(fontSize: screenWidth * 0.03, color: Colors.black54),
          ),
          SizedBox(height: screenHeight * 0.01),
        ],
      ),
    );
  }

  Widget _menuItem(BuildContext context, String title, IconData icon,
      VoidCallback onTap, double screenWidth) {
    final boxWidth = screenWidth * 0.4;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: boxWidth,
        height: boxWidth * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 4,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: screenWidth * 0.09, color: Colors.black),
            SizedBox(height: screenWidth * 0.02),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: screenWidth * 0.03, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
