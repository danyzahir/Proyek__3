import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyek3/screens/rekap_absensi_anak.dart';
import 'package:proyek3/screens/rekap_absensi_tkq.dart';
import 'absensi.dart';
import 'home_screen.dart';
import 'nilai.dart';
import 'data_guru_anak.dart';
import 'login.dart';
import 'rekap_guru_sdit.dart';
import 'rekap_guru_tkq.dart';

class RekapScreen extends StatelessWidget {
  final String username;

  const RekapScreen({super.key, required this.username});

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
              // Header
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
                              username,
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
                      "REKAP ABSENSI",
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

              // Info Box
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Container(
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
                            "Rabu, 13 Oktober 2023",
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "Pembagian Rapot",
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Menu Box (Wrap Layout)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Wrap(
                  spacing: screenWidth * 0.04,
                  runSpacing: screenHeight * 0.02,
                  alignment: WrapAlignment.center,
                  children: [
                    _menuBox(
                      context,
                      "Rekap Absensi Guru SDIT",
                      Icons.people_alt,
                      screenWidth,
                      screenHeight,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RekapAbsenGuruSDIT(username: username),
                          ),
                        );
                      },
                    ),
                    _menuBox(
                      context,
                      "Rekap Absensi Guru TKQ",
                      Icons.people_alt,
                      screenWidth,
                      screenHeight,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RekapAbsenGuruTKQ(username: username),
                          ),
                        );
                      },
                    ),
                    _menuBox(
                      context,
                      "Rekap Absensi\nAnak SDIT",
                      Icons.people,
                      screenWidth,
                      screenHeight,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RekapAbsensAnakSDITKelas(username: username),
                          ),
                        );
                      },
                    ),
                    _menuBox(
                      context,
                      "Rekap Absensi\nAnak TKQ",
                      Icons.people,
                      screenWidth,
                      screenHeight,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RekapAbsenTKQ(username: username),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),

      // Bottom Navigation
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
                HomeScreen(username: username), false, screenWidth),
            _navItem(context, "Absensi", Icons.assignment_ind_rounded,
                AbsensiScreen(username: username), false, screenWidth),
            _navItem(context, "Nilai", Icons.my_library_books_rounded,
                NilaiScreen(username: username), false, screenWidth),
            _navItem(context, "Data Guru & Anak", Icons.person,
                DataScreen(username: username), false, screenWidth),
            _navItem(context, "Rekap Absensi", Icons.receipt_long,
                RekapScreen(username: username), true, screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _menuBox(
    BuildContext context,
    String title,
    IconData icon,
    double screenWidth,
    double screenHeight,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width:
            (screenWidth - (screenWidth * 0.08 * 2 + screenWidth * 0.04)) / 2,
        height: screenHeight * 0.16,
        child: Container(
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
              SizedBox(height: screenWidth * 0.01),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.03,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
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
