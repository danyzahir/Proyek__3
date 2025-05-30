import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyek3/screens/absensi_tkq_absen.dart';
import 'absensi.dart';
import 'home_screen.dart';
import 'nilai.dart';
import 'data_guru_anak.dart';
import 'login.dart';
import 'rekap_absensi.dart';

class AbsenTKQ extends StatelessWidget {
  final String username;

  const AbsenTKQ({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                      "ABSENSI - TKQ",
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

              // Menu Box
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Wrap(
                  spacing: screenWidth * 0.04,
                  runSpacing: screenHeight * 0.02,
                  alignment: WrapAlignment.center,
                  children: [
                    _menuBox(
                      "Kelas A",
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: screenWidth * 0.07,
                        child: Text(
                          "A",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      screenWidth,
                      screenHeight,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AbsensiTKQAbsen(
                              username: username,
                              kelas: "KELAS A",
                            ),
                          ),
                        );
                      },
                    ),
                    _menuBox(
                      "Kelas B",
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: screenWidth * 0.07,
                        child: Text(
                          "B",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      screenWidth,
                      screenHeight,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AbsensiTKQAbsen(
                              username: username,
                              kelas: "KELAS B",
                            ),
                          ),
                        );
                      },
                    ),
                    _menuBox(
                      "Kelas C",
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: screenWidth * 0.07,
                        child: Text(
                          "C",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      screenWidth,
                      screenHeight,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AbsensiTKQAbsen(
                              username: username,
                              kelas: "KELAS C",
                            ),
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
                AbsensiScreen(username: username), true, screenWidth),
            _navItem(context, "Nilai", Icons.my_library_books_rounded,
                NilaiScreen(username: username), false, screenWidth),
            _navItem(context, "Data Guru & Anak", Icons.person,
                DataScreen(username: username), false, screenWidth),
            _navItem(context, "Rekap Absensi", Icons.receipt_long,
                RekapScreen(username: username), false, screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _menuBox(
    String title,
    Widget iconWidget,
    double screenWidth,
    double screenHeight,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: (screenWidth - (screenWidth * 0.08 * 2 + screenWidth * 0.04)) / 2,
      height: screenHeight * 0.16,
      child: GestureDetector(
        onTap: onTap,
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
              iconWidget,
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
